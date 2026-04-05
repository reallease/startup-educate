import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/models.dart';
import '../../../services/question_bank.dart';
import '../../../services/storage_service.dart';

class QuizPage extends StatefulWidget {
  final String title;
  final String? subject;
  final int questionCount;

  const QuizPage({
    super.key,
    required this.title,
    this.subject,
    this.questionCount = 10,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  static const _primaryPurple = Color(0xFF7C3AED);

  List<Question> _questions = [];
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  final List<bool> _answers = [];
  int _secondsElapsed = 0;
  Timer? _timer;
  bool _showResults = false;
  bool _reviewMode = false;
  int? _reviewIndex;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadQuestions() {
    final questions =
        QuestionBank.getRandomQuestions(count: widget.questionCount, subject: widget.subject);
    setState(() {
      _questions = questions;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_showResults) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
      _answers.add(index == _questions[_currentIndex].correctIndex);
    });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 >= _questions.length) {
      _finishQuiz();
    } else {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _answered = false;
      });
    }
  }

  void _finishQuiz() {
    _timer?.cancel();
    final correctCount = _answers.where((a) => a).length;
    final result = QuizResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: widget.title,
      date: DateTime.now(),
      totalQuestions: _answers.length,
      correctAnswers: correctCount,
      timeSpentSeconds: _secondsElapsed,
      answers: _answers,
    );
    StorageService.saveQuizResult(result);
    setState(() {
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) return _buildResultsScreen(context);
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text(widget.title), backgroundColor: _primaryPurple),
        body: const Center(child: CircularProgressIndicator(color: _primaryPurple)),
      );
    }
    return _buildQuizScreen(context);
  }

  Widget _buildQuizScreen(BuildContext context) {
    final question = _questions[_currentIndex];
    final isCorrect = _selectedIndex == question.correctIndex;
    final progress = (_currentIndex + 1) / _questions.length;

    const labels = ['A', 'B', 'C', 'D', 'E'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: _primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Timer & progress row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pergunta ${_currentIndex + 1}/${_questions.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _primaryPurple,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: _primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 18, color: _primaryPurple),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(_secondsElapsed),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Progress bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: _primaryPurple.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(_primaryPurple),
              minHeight: 6,
            ),
            const SizedBox(height: 16),
            // Question card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _primaryPurple.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _primaryPurple.withOpacity(0.2)),
                      ),
                      child: Text(
                        question.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E1E2C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Options
                    ...List.generate(question.options.length, (i) {
                      final isSelected = _selectedIndex == i;
                      final isCorrectOption = i == question.correctIndex;
                      Color borderColor, bgColor, labelColor, labelBgColor;

                      if (_answered) {
                        if (isCorrectOption) {
                          borderColor = Colors.green;
                          bgColor = Colors.green.withOpacity(0.08);
                          labelColor = Colors.white;
                          labelBgColor = Colors.green;
                        } else if (isSelected && !isCorrectOption) {
                          borderColor = Colors.red;
                          bgColor = Colors.red.withOpacity(0.08);
                          labelColor = Colors.white;
                          labelBgColor = Colors.red;
                        } else {
                          borderColor = Colors.grey.shade300;
                          bgColor = Colors.white;
                          labelColor = Colors.grey.shade600;
                          labelBgColor = Colors.grey.shade200;
                        }
                      } else {
                        borderColor = const Color(0xFF7C3AED).withOpacity(0.3);
                        bgColor = Colors.white;
                        labelColor = Colors.white;
                        labelBgColor = _primaryPurple;
                      }

                      return GestureDetector(
                        onTap: () => _selectOption(i),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: labelBgColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  labels[i],
                                  style: TextStyle(
                                    color: labelColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.options[i],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF1E1E2C),
                                  ),
                                ),
                              ),
                              if (_answered && isCorrectOption)
                                const Icon(Icons.check_circle, color: Colors.green, size: 22),
                              if (_answered && isSelected && !isCorrectOption)
                                const Icon(Icons.cancel_outlined, color: Colors.red, size: 22),
                            ],
                          ),
                        ),
                      );
                    }),
                    // Explanation & next button
                    if (_answered) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? Colors.green.withOpacity(0.08)
                              : Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCorrect ? Colors.green : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel_outlined,
                                  color: isCorrect ? Colors.green : Colors.red,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isCorrect ? 'Correto!' : 'Incorreto',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isCorrect ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              question.explanation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1E1E2C),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _currentIndex + 1 >= _questions.length ? 'Finalizar Quiz' : 'Próxima',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen(BuildContext context) {
    final correctCount = _answers.where((a) => a).length;
    final wrongCount = _answers.length - correctCount;
    final accuracy = _answers.isNotEmpty ? correctCount / _answers.length : 0.0;
    final accuracyPercent = (accuracy * 100).toInt();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Resultado'),
        backgroundColor: _primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.replay_outlined),
            onPressed: () {
              setState(() {
                _showResults = false;
                _currentIndex = 0;
                _selectedIndex = null;
                _answered = false;
                _answers.clear();
                _secondsElapsed = 0;
                _reviewMode = false;
                _reviewIndex = null;
                _loadQuestions();
                _startTimer();
              });
            },
            tooltip: 'Reiniciar',
          ),
          IconButton(
            icon: const Icon(Icons.list_alt_outlined),
            onPressed: () {
              setState(() {
                _reviewMode = !_reviewMode;
                _reviewIndex = null;
              });
            },
            tooltip: 'Revisão',
          ),
        ],
      ),
      body: _reviewMode ? _buildReviewScreen(context) : _buildResultsSummary(accuracyPercent),
    );
  }

  Widget _buildResultsSummary(int accuracyPercent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Accuracy circle
          Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: accuracyPercent >= 70
                    ? [_primaryPurple, const Color(0xFFA78BFA)]
                    : [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _primaryPurple.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$accuracyPercent%',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Precisão',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Stats cards
          _buildStatsCard(),
          const SizedBox(height: 24),
          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showResults = false;
                  _currentIndex = 0;
                  _selectedIndex = null;
                  _answered = false;
                  _answers.clear();
                  _secondsElapsed = 0;
                  _reviewMode = false;
                  _reviewIndex = null;
                  _loadQuestions();
                  _startTimer();
                });
              },
              icon: const Icon(Icons.replay_outlined),
              label: const Text('Tentar Novamente', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _reviewMode = true;
                  _reviewIndex = null;
                });
              },
              icon: const Icon(Icons.list_alt_outlined),
              label: const Text('Revisar Questões', style: TextStyle(fontSize: 16)),
              style: OutlinedButton.styleFrom(
                foregroundColor: _primaryPurple,
                side: const BorderSide(color: _primaryPurple),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final correctCount = _answers.where((a) => a).length;
    final wrongCount = _answers.length - correctCount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _primaryPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryPurple.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(Icons.check_circle, 'Corretas', '$correctCount', Colors.green),
              _statItem(Icons.cancel_outlined, 'Erradas', '$wrongCount', Colors.red),
              _statItem(Icons.quiz, 'Total', '${_answers.length}', _primaryPurple),
            ],
          ),
          const Divider(height: 30, color: Color(0xFFE0E0E0)),
          _statItem(Icons.timer_outlined, 'Tempo', _formatTime(_secondsElapsed), _primaryPurple),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
        ),
      ],
    );
  }

  Widget _buildReviewScreen(BuildContext context) {
    const labels = ['A', 'B', 'C', 'D', 'E'];

    if (_reviewIndex != null) {
      final question = _questions[_reviewIndex!];
      final wasCorrect = _answers[_reviewIndex!];

      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => _reviewIndex = null),
                  icon: const Icon(Icons.arrow_back),
                  color: _primaryPurple,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pergunta ${_reviewIndex! + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _primaryPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Question
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _primaryPurple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _primaryPurple.withOpacity(0.2)),
              ),
              child: Text(
                question.question,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            // Options
            ...List.generate(question.options.length, (i) {
              final isCorrectOption = i == question.correctIndex;
              Color borderColor = Colors.grey.shade300;
              Color bgColor = Colors.white;
              Color labelColor = Colors.grey.shade700;
              Color labelBg = Colors.grey.shade300;

              if (isCorrectOption) {
                borderColor = Colors.green;
                bgColor = Colors.green.withOpacity(0.08);
                labelColor = Colors.white;
                labelBg = Colors.green;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: labelBg,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          color: labelColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        question.options[i],
                        style: const TextStyle(fontSize: 14, color: Color(0xFF1E1E2C)),
                      ),
                    ),
                    if (isCorrectOption)
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            // Result badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: wasCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: wasCorrect ? Colors.green : Colors.red),
              ),
              child: Text(
                wasCorrect ? 'Você acertou' : 'Você errou',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: wasCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Explanation
            const Text(
              'Explicação:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _primaryPurple),
            ),
            const SizedBox(height: 6),
            Text(
              question.explanation,
              style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF1E1E2C)),
            ),
            const SizedBox(height: 24),
            // Navigation buttons
            Row(
              children: [
                if (_reviewIndex! > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _reviewIndex = _reviewIndex! - 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Anterior'),
                    ),
                  ),
                const SizedBox(width: 12),
                if (_reviewIndex! < _questions.length - 1)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _reviewIndex = _reviewIndex! + 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Próxima'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }

    // Review list
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _reviewMode = false),
                icon: const Icon(Icons.arrow_back),
                color: _primaryPurple,
              ),
              const SizedBox(width: 8),
              const Text(
                'Revisão das Questões',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryPurple),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_questions.length, (i) {
            final question = _questions[i];
            final wasCorrect = _answers[i];

            return GestureDetector(
              onTap: () => setState(() => _reviewIndex = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: wasCorrect ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: wasCorrect ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        wasCorrect ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pergunta ${i + 1}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _primaryPurple,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            question.question.length > 60
                                ? '${question.question.substring(0, 60)}...'
                                : question.question,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E1E2C),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: _primaryPurple),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
