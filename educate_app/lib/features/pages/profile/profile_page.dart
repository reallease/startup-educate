import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Meu Perfil', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho (sem degradê, mais limpo)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFEEF2FF),
                    child: Icon(Icons.person, size: 40, color: Color(0xFF4F46E5)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Thomas David',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'thomasdavid@gmail.com',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Estatísticas rápidas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat('127', 'Dias de Estudo'),
                _buildStat('89%', 'Taxa de Acerto'),
                _buildStat('45', 'Simulados'),
              ],
            ),
            const SizedBox(height: 20),

            // Progresso Geral
            _buildSectionCard(
              title: 'Progresso Geral',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _progressBox('2.847', 'Questões Certas', Color(0xFFE8F5E9)),
                      _progressBox('358', 'Questões Erradas', Color(0xFFFFEBEE), isError: true),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Simulados Recentes
            _buildSectionCard(
              title: 'Simulados Recentes',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              child: Column(
                children: [
                  _simuladoItem('ENEM 2023 - Matemática', 'Há 2 dias', '92%', Colors.green),
                  const Divider(),
                  _simuladoItem('Linguagens e Códigos', 'Há 5 dias', '76%', Colors.orange),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Matérias
            _buildSectionCard(
              title: 'Matérias',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              child: Column(
                children: [
                  _subjectRow('Matemática', 0.89, Colors.green),
                  _subjectRow('Português', 0.76, Colors.orange),
                  _subjectRow('História', 0.84, Colors.lightBlue),
                  _subjectRow('Ciências', 0.68, Colors.red),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Conquistas
            _buildSectionCard(
              title: 'Conquistas',
              trailing: const Icon(Icons.emoji_events, color: Colors.amber),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _achievement('Sequência', '30 dias', Icons.local_fire_department, Colors.orange),
                  _achievement('100 Simulados', '', Icons.check_circle, Colors.blue),
                  _achievement('Nota Máxima', '', Icons.star, Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botões
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {},
                child: const Text('Ver Relatório Completo', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.share_outlined, color: Colors.black),
                label: const Text('Compartilhar Progresso', style: TextStyle(color: Colors.black)),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Componentes reutilizáveis
  static Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  static Widget _buildSectionCard({required String title, Widget? trailing, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  static Widget _progressBox(String value, String label, Color bg, {bool isError = false}) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: isError ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  static Widget _simuladoItem(String title, String date, String percent, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(date, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        Text(percent, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  static Widget _subjectRow(String name, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${(progress * 100).toInt()}%', style: TextStyle(color: color)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }

  static Widget _achievement(String title, String subtitle, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (subtitle.isNotEmpty)
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}