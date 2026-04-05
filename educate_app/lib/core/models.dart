class Question {
  final String id;
  final String subject;
  final String category;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String difficulty;

  Question({
    required this.id,
    required this.subject,
    required this.category,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.difficulty = 'Médio',
  });
}

class QuizResult {
  final String id;
  final String title;
  final DateTime date;
  final int totalQuestions;
  final int correctAnswers;
  final int timeSpentSeconds;
  final List<bool> answers;

  QuizResult({
    required this.id,
    required this.title,
    required this.date,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeSpentSeconds,
    required this.answers,
  });

  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
  int get correct => correctAnswers;
  int get wrong => totalQuestions - correctAnswers;
}

class Flashcard {
  final String id;
  final String subject;
  final String front;
  final String back;
  final bool mastered;

  Flashcard({
    required this.id,
    required this.subject,
    required this.front,
    required this.back,
    this.mastered = false,
  });
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool unlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.unlocked = false,
  });
}
