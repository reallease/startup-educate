import 'package:flutter/material.dart';

class VestibularScreen extends StatelessWidget {
  const VestibularScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 28),
                onPressed: () => Navigator.pop(context), // 👈 volta pra anterior
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seu Progresso',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Continue estudando!',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _ProgressInfo(title: 'Acertos', value: '87%'),
                        _ProgressInfo(title: 'Simulados', value: '24'),
                        _ProgressInfo(title: 'Estudadas', value: '156h'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- SIMULADOS DISPONÍVEIS ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Simulados Disponíveis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Ver todos',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSimuladoCard(
                title: 'ENEM 2023',
                subtitle: '180 questões • 3h30min • Dificuldade: Alta',
                tags: ['Matemática', 'Português'],
                statusColor: Colors.grey,
                statusText: 'Não iniciado',
                actionText: 'Iniciar',
                actionColor: Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildSimuladoCard(
                title: 'Ciências da Natureza',
                subtitle: '45 questões • 1h30min',
                tags: ['Biologia', 'Química'],
                statusColor: Colors.orange,
                statusText: 'Em andamento',
                progress: 0.67,
                actionText: 'Continuar',
                actionColor: Colors.orange,
              ),
              const SizedBox(height: 12),
              _buildSimuladoCard(
                title: 'Linguagens e Códigos',
                subtitle: '45 questões • Concluído',
                tags: ['Literatura', 'Redação'],
                statusColor: Colors.green,
                statusText: '92% de acertos',
                actionText: 'Revisar',
                actionColor: Colors.green,
              ),
              const SizedBox(height: 24),

              // --- HISTÓRICO RECENTE ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Histórico Recente',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Ver histórico completo',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildHistoricoItem(
                title: 'Matemática Básica',
                date: 'Ontem às 14:30',
                percent: 95,
                result: '38/40',
              ),
              const SizedBox(height: 8),
              _buildHistoricoItem(
                title: 'História do Brasil',
                date: '2 dias atrás',
                percent: 78,
                result: '23/30',
              ),
              const SizedBox(height: 8),
              _buildHistoricoItem(
                title: 'Física Moderna',
                date: '3 dias atrás',
                percent: 65,
                result: '13/20',
              ),
              const SizedBox(height: 24),

              // --- RECURSOS EXTRAS ---
              const Text(
                'Recursos Extras',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildExtraCard(
                    icon: Icons.tips_and_updates,
                    title: 'Dicas de Estudo',
                    subtitle: 'Estratégias e técnicas',
                    action: 'Acessar',
                  ),
                  _buildExtraCard(
                    icon: Icons.insert_chart_outlined,
                    title: 'Relatórios',
                    subtitle: 'Análise detalhada',
                    action: 'Ver mais',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: _buildExtraCard(
                  icon: Icons.calendar_today,
                  title: 'Cronograma',
                  subtitle: 'Organize seus estudos',
                  action: 'Criar',
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- COMPONENTES PERSONALIZADOS ---
  static Widget _buildSimuladoCard({
    required String title,
    required String subtitle,
    required List<String> tags,
    required Color statusColor,
    required String statusText,
    required String actionText,
    required Color actionColor,
    double? progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: tags
                .map((tag) => Chip(
                      label: Text(tag,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87)),
                      backgroundColor: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    ))
                .toList(),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(statusText,
                  style: TextStyle(
                      color: statusColor, fontWeight: FontWeight.w600)),
              Text(
                actionText,
                style: TextStyle(
                  color: actionColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildHistoricoItem({
    required String title,
    required String date,
    required int percent,
    required String result,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 4),
              Text(date,
                  style:
                      const TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$percent%',
                  style: TextStyle(
                      color: percent >= 75 ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(result,
                  style: const TextStyle(color: Colors.black54, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildExtraCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String action,
    double? width,
  }) {
    return Container(
      width: width ?? 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 28),
          const SizedBox(height: 8),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 4),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 8),
          Text(
            action,
            style: const TextStyle(
                color: Color(0xFF6366F1), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET PARA O PROGRESSO ---
class _ProgressInfo extends StatelessWidget {
  final String title;
  final String value;

  const _ProgressInfo({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}