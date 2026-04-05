import '../core/models.dart';

class Gamification {
  static const _xpPerCorrect = 10;
  static const _xpPerStreakDay = 5;

  static int calculateXP({required int correctAnswers, required int streakDays}) {
    return (correctAnswers * _xpPerCorrect) + (streakDays * _xpPerStreakDay);
  }

  static List<Achievement> getAchievements({
    required int totalCorrect,
    required int totalQuestions,
    required int streak,
    required double bestAccuracy,
  }) {
    return [
      Achievement(
        id: 'first_question',
        title: 'Primeira Questão',
        description: 'Responda sua primeira questão',
        icon: 'check_circle',
        unlocked: totalQuestions >= 1,
      ),
      Achievement(
        id: 'streak_7',
        title: 'Em Chamas',
        description: '7 dias consecutivos de estudo',
        icon: 'local_fire_department',
        unlocked: streak >= 7,
      ),
      Achievement(
        id: 'streak_30',
        title: 'Super Sequência',
        description: '30 dias consecutivos de estudo',
        icon: 'local_fire_department',
        unlocked: streak >= 30,
      ),
      Achievement(
        id: 'fifty_correct',
        title: 'Meio-Caminho',
        description: 'Acerte 50 questões',
        icon: 'star',
        unlocked: totalCorrect >= 50,
      ),
      Achievement(
        id: 'hundred_questions',
        title: 'Centurião',
        description: 'Responda 100 questões',
        icon: 'emoji_events',
        unlocked: totalQuestions >= 100,
      ),
      Achievement(
        id: 'perfect_quiz',
        title: 'Nota Máxima',
        description: 'Acerte 90%+ em um simulado',
        icon: 'star',
        unlocked: bestAccuracy >= 0.9,
      ),
      Achievement(
        id: 'five_hundred',
        title: 'Mestre do Conhecimento',
        description: 'Acerte 500 questões',
        icon: 'workspace_premium',
        unlocked: totalCorrect >= 500,
      ),
      Achievement(
        id: 'quiz_10',
        title: 'Persistente',
        description: 'Complete 10 simulados',
        icon: 'task_alt',
        unlocked: totalQuestions >= 10, // approximating quizzes
      ),
    ];
  }
}
