import 'package:flutter/material.dart';
import '../../quiz/quiz_page.dart';
import '../../../../../core/models.dart';
import '../../../../../services/question_bank.dart';
import '../../../../../services/storage_service.dart';

class ConcursosScreen extends StatefulWidget {
  const ConcursosScreen({super.key});

  @override
  State<ConcursosScreen> createState() => _ConcursosScreenState();
}

class _ConcursosScreenState extends State<ConcursosScreen> {
  int _streak = 0;
  int _totalQuestions = 0;
  int _correctAnswers = 0;
  String _selectedFilter = 'Todos';

  final List<Map<String, dynamic>> _concursos = [
    {
      'title': 'Simulado Geral - Concursos',
      'subtitle': '60 questões • 2h00min',
      'tags': ['Português', 'Matemática', 'Informática'],
      'difficulty': 'Médio',
      'subject': null,
      'count': 10,
    },
    {
      'title': 'Português - Concursos',
      'subtitle': '30 questões • 45min',
      'tags': ['Gramática', 'Interpretação'],
      'difficulty': 'Médio',
      'subject': 'Português',
      'count': 3,
    },
    {
      'title': 'Raciocínio Lógico',
      'subtitle': '20 questões • 30min',
      'tags': ['Lógica', 'Matemática'],
      'difficulty': 'Alto',
      'subject': null,
      'count': 1,
    },
    {
      'title': 'Informática Básica',
      'subtitle': '20 questões • 30min',
      'tags': ['Windows', 'Office'],
      'difficulty': 'Médio',
      'subject': 'Informática',
      'count': 2,
    },
    {
      'title': 'Direito Constitucional',
      'subtitle': '25 questões • 40min',
      'tags': ['CF/88', 'Artigos'],
      'difficulty': 'Alto',
      'subject': 'Direito',
      'count': 1,
    },
    {
      'title': 'Conhecimentos Gerais',
      'subtitle': '20 questões • 30min',
      'tags': ['Atualidades', 'Brasil'],
      'difficulty': 'Médio',
      'subject': null,
      'count': 8,
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
      final results = StorageService.getQuizResults();
      _correctAnswers = results.fold<int>(0, (p, r) => p + r.correctAnswers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedFilter == 'Todos'
        ? _concursos
        : _concursos.where((s) => s['tags'].contains(_selectedFilter)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
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
                          'Concursos Públicos',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _stat('Acertos', '$_correctAnswers', Colors.white.withValues(alpha: 0.9)),
                          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                          _stat('Questões', '$_totalQuestions', Colors.white.withValues(alpha: 0.9)),
                          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                          _stat('Sequência', '${_streak}d', Colors.white.withValues(alpha: 0.9)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: ['Todos', 'Português', 'Matemática', 'Informática']
                      .map((tag) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _Chip(tag: tag, selected: _selectedFilter == tag, onTap: () => setState(() => _selectedFilter = tag)),
                          ))
                      .toList(),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final sim = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: _Card(
                      title: sim['title'] as String,
                      subtitle: sim['subtitle'] as String,
                      tags: (sim['tags'] as List).cast<String>(),
                      difficulty: sim['difficulty'] as String,
                      subject: sim['subject'] as String?,
                      questionCount: sim['count'] as int,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizPage(
                              title: sim['title'] as String,
                              subject: sim['subject'] as String?,
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

class _Chip extends StatelessWidget {
  final String tag;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.tag, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF22C55E) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(tag,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              )),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title, subtitle, difficulty;
  final List<String> tags;
  final String? subject;
  final int questionCount;
  final VoidCallback onTap;

  const _Card({
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.difficulty,
    required this.subject,
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
                      color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.quiz_outlined, color: Color(0xFF22C55E), size: 22),
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
                  const Icon(Icons.play_arrow, color: Color(0xFF22C55E), size: 28),
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
                      color: difficulty == 'Alto' ? Colors.red.shade50 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(difficulty,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: difficulty == 'Alto' ? Colors.red : Colors.orange,
                        )),
                  ),
                  const Spacer(),
                  Text('$questionCount questões',
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
