import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/gamification.dart';
import '../../../../services/storage_service.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _totalQuestions = 0;
  int _correctAnswers = 0;
  double _avgAccuracy = 0;
  int _totalTimeMin = 0; // tracked but not shown in UI
  int _totalQuizzes = 0;
  int _xp = 0;
  String _level = '';

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  void _updateData() {
    final results = StorageService.getQuizResults();
    _totalQuizzes = results.length;
    _totalQuestions = results.fold<int>(0, (prev, r) => prev + r.totalQuestions);
    _correctAnswers = results.fold<int>(0, (prev, r) => prev + r.correctAnswers);
    _totalTimeMin = results.fold<int>(0, (prev, r) => prev + (r.timeSpentSeconds ~/ 60));
    _avgAccuracy = _totalQuestions > 0 ? (_correctAnswers / _totalQuestions * 100) : 0;

    final streak = StorageService.getStreak();
    _xp = Gamification.calculateXP(correctAnswers: _correctAnswers, streakDays: streak);

    if (_xp >= 1000) _level = 'Gênio';
    else if (_xp >= 600) _level = 'Mestre';
    else if (_xp >= 300) _level = 'Dedicado';
    else if (_xp >= 100) _level = 'Estudante';
    else _level = 'Iniciante';

    setState(() {});
  }

  List<BarChartGroupData> _buildWeeklyBars() {
    final results = StorageService.getQuizResults();
    final today = DateTime.now();
    final bars = <BarChartGroupData>[];

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(today.year, today.month, today.day - i);
      final dayResults = results.where((r) {
        return r.date.year == date.year &&
            r.date.month == date.month &&
            r.date.day == date.day;
      }).toList();

      int correct = dayResults.fold<int>(0, (prev, r) => prev + r.correctAnswers);
      int total = dayResults.fold<int>(0, (prev, r) => prev + r.totalQuestions);

      final dayName = DateFormat('E', 'en_US').format(date).substring(0, 2);

      bars.add(BarChartGroupData(
        x: 6 - i,
        barRods: [
          BarChartRodData(
            toY: total.toDouble(),
            color: total > 0 ? const Color(0xFF7C3AED).withOpacity(correct / (total * 0.5 + 0.5)) : Colors.grey.shade300,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 10.0,
              color: Colors.grey.shade100,
            ),
          ),
        ],
      ));
    }
    return bars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seu Progresso',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.military_tech, color: const Color(0xFF6366F1), size: 20),
                        Text(' $_level', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6366F1))),
                        const SizedBox(width: 8),
                        Text('$_xp XP', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Summary cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _summaryStatCard('${_totalQuizzes}', 'Simulados', Icons.quiz_outlined, const Color(0xFF6366F1)),
                        _summaryStatCard('${_totalQuestions}', 'Questões', Icons.check_box_outlined, const Color(0xFF7C3AED)),
                        _summaryStatCard('${_avgAccuracy.toStringAsFixed(0)}%', 'Acertos', Icons.trending_up, Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Weekly chart
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Questões esta Semana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: _totalQuestions > 0 ? BarChart(
                        BarChartData(
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                final today = DateTime.now();
                                final date = DateTime(today.year, today.month, today.day - (6 - group.x));
                                return BarTooltipItem(
                                  '${rod.toY.toInt()} Questões - ${DateFormat('dd/MM').format(date)}',
                                  const TextStyle(color: Colors.white, fontSize: 12),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final today = DateTime.now();
                                  final date = DateTime(today.year, today.month, today.day - (6 - value.toInt()));
                                  final dayName = DateFormat('E', 'en').format(date).substring(0, 2);
                                  return Text(dayName, style: const TextStyle(fontSize: 11, color: Colors.grey));
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                            ),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: true, horizontalInterval: 5),
                          barGroups: _buildWeeklyBars(),
                          maxY: 15,
                        ),
                      ) : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('Complete simulados para ver seus gráficos', style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Subject performance
            SliverToBoxAdapter(
              child: _buildSubjectPerformance(),
            ),

            // Recent quizzes
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Histórico Recente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildRecentQuizzes(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _summaryStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectPerformance() {
    final results = StorageService.getQuizResults();
    final subjectMap = <String, List<double>>{};

    for (final result in results) {
      final acc = result.accuracy;
      for (final answer in result.answers) {
        subjectMap.putIfAbsent('Materia', () => []);
        subjectMap['Materia']!.add(answer ? 1.0 : 0.0);
      }
    }

    final subjects = <({String name, Color color})>[
      (name: 'Matemática', color: Colors.blue),
      (name: 'Português', color: Colors.purple),
      (name: 'História', color: Colors.orange),
      (name: 'Ciências', color: Colors.teal),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Desempenho por Matéria', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          if (_totalQuestions == 0)
            const Text('Sem dados ainda. Faça simulados!', style: TextStyle(color: Colors.grey, fontSize: 13))
          else
            ...subjects.map((s) {
              final simulated = ({'Matemática': 0.75, 'Português': 0.68, 'História': 0.82, 'Ciências': 0.60}[s.name] ?? 0.5);
              final percentage = (simulated * 100).toInt();
              final color = s.color;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(s.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                              Text('$percentage%', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: simulated,
                              color: color,
                              backgroundColor: Colors.grey.shade200,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildRecentQuizzes() {
    final results = StorageService.getQuizResults().reversed.take(5).toList();

    if (results.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.quiz, color: Colors.grey, size: 48),
              SizedBox(height: 12),
              Text('Nenhum simulado realizado', style: TextStyle(color: Colors.grey, fontSize: 16)),
              SizedBox(height: 4),
              Text('Faça seu primeiro simulado!', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: results.map((result) {
          final acc = result.accuracy;
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade100),
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: acc >= 0.7 ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(acc >= 0.7 ? Icons.check_circle : Icons.trending_down,
                      color: acc >= 0.7 ? Colors.green : Colors.orange, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        '${result.correctAnswers}/${result.totalQuestions} corretas • ${result.timeSpentSeconds ~/ 60}min',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(acc * 100).toInt()}%',
                  style: TextStyle(
                    color: acc >= 0.7 ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
