import 'package:flutter/material.dart';
import '../../../../services/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  int _dailyGoalMinutes = 60;
  int _dailyGoalQuestions = 30;
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = StorageService.getUserName() ?? '';
    _emailController.text = StorageService.getUserEmail() ?? '';
  }

  Future<void> _saveProfile() async {
    await StorageService.setUserName(_nameController.text.trim());
    await StorageService.setUserEmail(_emailController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nome', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Metas Diárias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule, color: Color(0xFF7C3AED)),
                      const SizedBox(width: 14),
                      const Text('Minutos de estudo', style: TextStyle(fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Text('$_dailyGoalMinutes', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _dailyGoalMinutes.toDouble(),
                    min: 10, max: 180, divisions: 17,
                    onChanged: (v) => setState(() => _dailyGoalMinutes = v.round()),
                    activeColor: const Color(0xFF7C3AED),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.quiz_outlined, color: Color(0xFF7C3AED)),
                      const SizedBox(width: 14),
                      const Text('Questões por dia', style: TextStyle(fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Text('$_dailyGoalQuestions', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _dailyGoalQuestions.toDouble(),
                    min: 5, max: 100, divisions: 19,
                    onChanged: (v) => setState(() => _dailyGoalQuestions = v.round()),
                    activeColor: const Color(0xFF7C3AED),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Preferências', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_outlined, color: Color(0xFF7C3AED)),
                      const SizedBox(width: 14),
                      const Expanded(child: Text('Notificações', style: TextStyle(fontWeight: FontWeight.w500))),
                      Switch(
                        value: _notifications,
                        onChanged: (v) => setState(() => _notifications = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Salvar configurações', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  const Text('Educate', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                  const Text('Versão 2.0.0', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
