import 'package:flutter/material.dart';
import '../../quiz/quiz_page.dart';
import '../../../../../core/models.dart';
import '../../../../../services/question_bank.dart';
import '../../../../../services/storage_service.dart';

class VestibularScreen extends StatefulWidget {
  const VestibularScreen({super.key});

  @override
  State<VestibularScreen> createState() => _VestibularScreenState();
}

class _VestibularScreenState extends State<VestibularScreen> {
  int _streak = 0;
  int _totalQuestions = 0;
  int _correctAnswers = 0;
  List<QuizResult> _results = [];
  String _selectedFilter = 'Todos';

  final List<Map<String, dynamic>> _simulados = [
    {
      'title': 'ENEM Completo 2024',
      'subtitle': '180 questões • 5h30min',
      'tags': ['Todas as matérias'],
      'difficulty': 'Alta',
      'subject': null,
      'count': 10,
    },
    {
      'title': 'Matemática - ENEM',
      'subtitle': '45 questões • 1h30min',
      'tags': ['Álgebra', 'Geometria', 'Estatística'],
      'difficulty': 'Média',
      'subject': 'Matemática',
      'count': 8,
    },
    {
      'title': 'Linguagens e Códigos',
      'subtitle': '45 questões • 1h30min',
      'tags': ['Português', 'Literatura'],
      'difficulty': 'Média',
      'subject': 'Português',
      'count': 8,
    },
    {
      'title': 'Ciências da Natureza',
      'subtitle': '45 questões • 1h30min',
      'tags': ['Biologia', 'Química', 'Física'],
      'difficulty': 'Alta',
      'subject': 'Ciências',
      'count': 8,
    },
    {
      'title': 'Ciências Humanas',
      'subtitle': '45 questões • 1h30min',
      'tags': ['História', 'Geografia'],
      'difficulty': 'Média',
      'subject': 'História',
      'count': 6,
    },
    {
      'title': 'Física',
      'subtitle': '20 questões • 40min',
      'tags': ['Mecânica', 'Óptica'],
      'difficulty': 'Alta',
      'subject': 'Física',
      'count': 1,
    },
    {
      'title': 'Química',
      'subtitle': '20 questões • 40min',
      'tags': ['Geral', 'Orgânica'],
      'difficulty': 'Média',
      'subject': 'Química',
      'count': 2,
    },
    {
      'title': 'Biologia',
      'subtitle': '20 questões • 40min',
      'tags': ['Ecologia', 'Citologia'],
      'difficulty': 'Média',
      'subject': 'Biologia',
      'count': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _streak = StorageService.getStreak();
      _totalQuestions = StorageService.totalQuestions;
      _results = StorageService.getQuizResults();
      _correctAnswers = _results.fold<int>(0, (p, r) => p + r.correctAnswers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedFilter == 'Todos'
        ? _simulados
        : _simulados.where((s) => s['tags'].contains(_selectedFilter)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF7C3AED),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'ENEM & Vestibulares',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _stat('Acertos', '$_correctAnswers', Colors.white.withValues(alpha: 0.9)),
                          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                          _stat('Questões', '$_totalQuestions', Colors.white.withValues(alpha: 0.9)),
                          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                          _stat('Sequência', '${_streak} dias', Colors.white.withValues(alpha: 0.9)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filter chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: ['Todos', 'Matemática', 'Português', 'Ciências', 'História', 'Física']
                      .map((tag) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _FilterChip(
                              label: tag,
                              selected: _selectedFilter == tag,
                              onTap: () => setState(() => _selectedFilter = tag),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),

            // Simulados list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final sim = filtered[index];
                  final subject = sim['subject'] as String?;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: _SimuladoCard(
                      title: sim['title'] as String,
                      subtitle: sim['subtitle'] as String,
                      tags: (sim['tags'] as List).cast<String>(),
                      difficulty: sim['difficulty'] as String,
                      subject: subject,
                      questionCount: sim['count'] as int,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizPage(
                              title: sim['title'] as String,
                              subject: subject,
                              questionCount: sim['count'] as int,
                            ),
                          ),
                        ).then((_) => _loadData());
                      },
                    ),
                  );
                },
                childCount: filtered.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF7C3AED) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _SimuladoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> tags;
  final String difficulty;
  final String? subject;
  final int questionCount;
  final VoidCallback onTap;

  const _SimuladoCard({
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.difficulty,
    this.subject,
    required this.questionCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.quiz_outlined, color: Color(0xFF7C3AED), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.play_arrow, color: Color(0xFF7C3AED), size: 28),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: tags
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: difficulty == 'Alta' ? Colors.red.shade50 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      difficulty,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: difficulty == 'Alta' ? Colors.red : Colors.orange,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text('$questionCount questões disponíveis',
                      style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
