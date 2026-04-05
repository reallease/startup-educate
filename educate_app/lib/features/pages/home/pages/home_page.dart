import 'package:flutter/material.dart';
import '../../../auth/view/pages/login_page.dart';
import '../../quiz/quiz_page.dart';
import '../../../../services/storage_service.dart';
import '../../../../core/gamification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';
  int _streak = 0;
  int _totalQuestions = 0;
  double _accuracy = 0;
  int _xp = 0;
  String _level = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final name = StorageService.getUserName() ?? 'Estudante';
    final streak = StorageService.getStreak();
    final totalQ = StorageService.totalQuestions;
    final results = StorageService.getQuizResults();

    double accuracy = 0;
    if (results.isNotEmpty) {
      final totalCorrect = results.fold<int>(0, (prev, r) => prev + r.correctAnswers);
      final totalAttempted = results.fold<int>(0, (prev, r) => prev + r.totalQuestions);
      accuracy = totalAttempted > 0 ? totalCorrect / totalAttempted * 100 : 0;
    }

    final xp = Gamification.calculateXP(
      correctAnswers: results.fold<int>(0, (prev, r) => prev + r.correctAnswers),
      streakDays: streak,
    );

    final level = _getLevel(xp);

    if (mounted) {
      setState(() {
        _userName = name;
        _streak = streak;
        _totalQuestions = totalQ;
        _accuracy = accuracy;
        _xp = xp;
        _level = level;
      });
    }
  }

  String _getLevel(int xp) {
    if (xp >= 1000) return 'Gênio';
    if (xp >= 600) return 'Mestre';
    if (xp >= 300) return 'Dedicado';
    if (xp >= 100) return 'Estudante';
    return 'Iniciante';
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: PullToRefresh(
        onRefresh: _loadData,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with user info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_greeting(), $_userName!',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_level • $_xp XP',
                          style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'settings',
                          child: ListTile(leading: Icon(Icons.settings), title: Text('Configurações')),
                        ),
                        const PopupMenuItem(
                          value: 'logout',
                          child: ListTile(leading: Icon(Icons.logout, color: Colors.red), title: Text('Sair')),
                        ),
                      ],
                      onSelected: (value) async {
                        if (value == 'logout') {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Streak card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sequência de Estudos',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_streak dias consecutivos',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const Icon(Icons.local_fire_department,
                          color: Colors.white, size: 36),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats
                Row(
                  children: [
                    _statCard('${_accuracy.toStringAsFixed(0)}%', 'Taxa Acerto'),
                    _statCard('$_totalQuestions', 'Questões'),
                    _statCard('$_streak', 'Sequência'),
                  ],
                ),
                const SizedBox(height: 20),

                // Quick actions
                const Text(
                  'Ações Rápidas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _quickAction(Icons.quiz, 'Simulado', const Color(0xFF6366F1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizPage(
                            title: 'Simulado Rápido',
                            questionCount: 10,
                          ),
                        ),
                      );
                    }),
                    _quickAction(Icons.timer, 'Cronômetro', const Color(0xFFFF6B35), () {
                      // Would need to navigate but MainScreen has bottom nav
                    }, tab: 2),
                    _quickAction(Icons.style, 'Flashcards', const Color(0xFF8B5CF6), () {}, route: '/flashcards'),
                  ],
                ),
                const SizedBox(height: 25),

                // Featured subjects
                const Text(
                  'Matérias Disponíveis',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                _subjectCard('Matemática', 12, Colors.blue, 'ENEM'),
                const SizedBox(height: 10),
                _subjectCard('Português', 8, Colors.purple, 'ENEM'),
                const SizedBox(height: 10),
                _subjectCard('História', 5, Colors.orange, 'ENEM'),
                const SizedBox(height: 10),
                _subjectCard('Ciências', 6, Colors.teal, 'ENEM'),
                const SizedBox(height: 25),

                // Recent activity
                const Text(
                  'Atividade Recente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                _buildRecentActivity(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, Color color, VoidCallback onTap, {int? tab, String? route}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subjectCard(String name, int pending, Color color, String category) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.book, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('$pending questões • $category',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: 0.3,
                  color: color,
                  backgroundColor: Colors.grey.shade200,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final results = StorageService.getQuizResults();
    if (results.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.quiz, color: Colors.grey, size: 48),
              SizedBox(height: 8),
              Text('Nenhum simulado realizado ainda.', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 4),
              Text('Comece um simulado agora!', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    final recent = results.take(3).toList();
    return Column(
      children: recent.map((r) {
        final accuracy = r.accuracy;
        final timeAgo = _timeAgo(r.date);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                accuracy >= 0.7 ? Icons.check_circle : Icons.star,
                color: accuracy >= 0.7 ? const Color(0xFF7C3AED) : Colors.orange,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text(timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Text(
                '${(accuracy * 100).toInt()}%',
                style: TextStyle(
                  color: accuracy >= 0.7 ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Agora mesmo';
    if (diff.inHours < 1) return '${diff.inMinutes}min atrás';
    if (diff.inHours < 24) return '${diff.inHours}h atrás';
    return '${diff.inDays}d atrás';
  }
}

class PullToRefresh extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final Widget child;

  const PullToRefresh({super.key, required this.onRefresh, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: child,
    );
  }
}
