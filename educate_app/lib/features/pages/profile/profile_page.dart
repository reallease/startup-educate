import 'package:flutter/material.dart';
import '../settings/settings_page.dart';
import '../../auth/view/pages/login_page.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/cloud_storage_service.dart';
import '../../../../services/storage_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      _profile = await AuthService.getUserProfile();
    } catch (_) {
      // Profile might not exist yet
      _profile = {
        'name': StorageService.getUserName() ?? 'Usuário',
        'email': StorageService.getUserEmail() ?? '',
        'xp': 0, 'streak': 0, 'total_quizzes': 0, 'total_questions': 0, 'study_minutes': 0,
        'objective': 'ENEM',
      };
    }
    setState(() => _loading = false);
  }

  String _getLevel(int xp) {
    if (xp >= 1000) return 'Gênio';
    if (xp >= 600) return 'Mestre';
    if (xp >= 300) return 'Dedicado';
    if (xp >= 100) return 'Estudante';
    return 'Iniciante';
  }

  int _nextLevel(int xp) {
    if (xp < 100) return 100;
    if (xp < 300) return 300;
    if (xp < 600) return 600;
    if (xp < 1000) return 1000;
    return 1500;
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await AuthService.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
    }
  }

  Future<void> _deleteAccount() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Excluir conta'),
        content: const Text('Essa ação é irreversível! Todos os seus dados, progresso e configurações serão perdidos permanentemente.\n\nDeseja continuar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        await AuthService.deleteAccount();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir conta: $e'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
      );
    }

    final name = _profile?['name'] ?? 'Usuário';
    final email = _profile?['email'] ?? '';
    final xp = (_profile?['xp'] ?? 0) as int;
    final streak = (_profile?['streak'] ?? 0) as int;
    final quizzes = (_profile?['total_quizzes'] ?? 0) as int;
    final questions = (_profile?['total_questions'] ?? 0) as int;
    final minutes = (_profile?['study_minutes'] ?? 0) as int;
    final objective = (_profile?['objective'] ?? 'ENEM') as String;
    final level = _getLevel(xp);
    final nextLvl = _nextLevel(xp);
    final progress = (xp / nextLvl).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Gradient header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()))
                                .then((_) => _loadProfile());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.settings, color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Avatar
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'U',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(email, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$level • $objective',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // XP Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('$xp XP', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('Próximo: $nextLvl XP', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _statCard(Icons.local_fire_department, '$streak', 'Sequência'),
                    _statCard(Icons.quiz_outlined, '$quizzes', 'Simulados'),
                    _statCard(Icons.description_outlined, '$questions', 'Questões'),
                    _statCard(Icons.schedule_outlined, '${minutes}min', 'Estudo'),
                  ],
                ),
              ),
            ),

            // Menu items
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _menuItem(Icons.person_outline, 'Editar perfil', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())).then((_) => _loadProfile());
                    }),
                    _menuItem(Icons.flag_outlined, 'Objetivo: $objective', null),
                    _menuItem(Icons.card_travel_outlined, 'Ranking', () {
                      _showLeaderboard(context);
                    }),
                    _menuItem(Icons.help_outline, 'FAQ / Suporte', null),
                    _menuItem(Icons.privacy_tip_outlined, 'Política de Privacidade', null),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    _menuItem(Icons.logout, 'Sair da conta', _logout, color: Colors.red),
                    _menuItem(Icons.delete_outline, 'Excluir conta', _deleteAccount, color: Colors.red),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF7C3AED), size: 22),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback? onTap, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: color ?? const Color(0xFF7C3AED), size: 22),
                const SizedBox(width: 14),
                Expanded(child: Text(title, style: TextStyle(fontSize: 15, color: color ?? const Color(0xFF111827)))),
                if (onTap != null) Icon(Icons.arrow_forward_ios, size: 16, color: color ?? Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLeaderboard(BuildContext context) async {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => FutureBuilder<List<Map<String, dynamic>>>(
        future: CloudStorageService.getLeaderboard(),
        builder: (ctx, snap) {
          if (!snap.hasData) return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))));
          final users = snap.data!;
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, controller) => SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Ranking Global', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...users.asMap().entries.map<Widget>((entry) {
                    final i = entry.key;
                    final u = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: i == 0 ? const Color(0xFF7C3AED).withValues(alpha: 0.08) : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: i < 3 ? const Color(0xFF7C3AED) : Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: i < 3 ? Colors.white : Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(u['name'] ?? 'Anônimo', style: const TextStyle(fontWeight: FontWeight.w600))),
                          Text('${u['xp']} XP', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
