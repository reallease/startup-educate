import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models.dart';

class StorageService {
  static const _streakKey = 'streak_days';
  static const _lastStudyDate = 'last_study_date';
  static const _totalQuestionsKey = 'total_questions';
  static const _quizResultsKey = 'quiz_results';
  static const _studyMinutesKey = 'study_minutes';
  static const _userAchievementsKey = 'achievements';
  static const _selectedSubjectKey = 'selected_subject';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';
  static const _flashcardProgressKey = 'flashcard_progress';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getUserName() => _prefs.getString(_userNameKey);
  static Future<void> setUserName(String name) => _prefs.setString(_userNameKey, name);

  static String? getUserEmail() => _prefs.getString(_userEmailKey);
  static Future<void> setUserEmail(String email) => _prefs.setString(_userEmailKey, email);

  static int getStreak() => _prefs.getInt(_streakKey) ?? 0;

  static Future<void> recordStudyDay() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';
    final lastStr = _prefs.getString(_lastStudyDate);

    if (lastStr != todayStr) {
      int streak = _prefs.getInt(_streakKey) ?? 0;
      if (lastStr != null) {
        final lastDate = DateTime.parse(lastStr);
        final diff = today.difference(lastDate).inDays;
        if (diff > 1) streak = 0;
      }
      streak++;
      await _prefs.setInt(_streakKey, streak);
      await _prefs.setString(_lastStudyDate, todayStr);
    }
  }

  static int get totalQuestions => _prefs.getInt(_totalQuestionsKey) ?? 0;

  static Future<void> addQuestionsAnswered(int count) async {
    await _prefs.setInt(_totalQuestionsKey, (_prefs.getInt(_totalQuestionsKey) ?? 0) + count);
    await recordStudyDay();
  }

  static int getStudyMinutes() => _prefs.getInt(_studyMinutesKey) ?? 0;

  static Future<void> addStudyMinutes(int minutes) async {
    await _prefs.setInt(_studyMinutesKey, (_prefs.getInt(_studyMinutesKey) ?? 0) + minutes);
    await recordStudyDay();
  }

  static List<QuizResult> getQuizResults() {
    final data = _prefs.getStringList(_quizResultsKey) ?? [];
    return data.map((e) {
      final map = jsonDecode(e) as Map<String, dynamic>;
      return QuizResult(
        id: map['id'] as String,
        title: map['title'] as String,
        date: DateTime.parse(map['date'] as String),
        totalQuestions: map['totalQuestions'] as int,
        correctAnswers: map['correctAnswers'] as int,
        timeSpentSeconds: map['timeSpentSeconds'] as int,
        answers: (map['answers'] as List).map((e) => e as bool).toList(),
      );
    }).toList();
  }

  static Future<void> saveQuizResult(QuizResult result) async {
    final results = getQuizResults();
    results.add(result);
    final encoded = results.map((r) => jsonEncode({
      'id': r.id,
      'title': r.title,
      'date': r.date.toIso8601String(),
      'totalQuestions': r.totalQuestions,
      'correctAnswers': r.correctAnswers,
      'timeSpentSeconds': r.timeSpentSeconds,
      'answers': r.answers,
    })).toList();
    await _prefs.setStringList(_quizResultsKey, encoded);
    await addQuestionsAnswered(result.totalQuestions);
  }

  static String? getSelectedSubject() => _prefs.getString(_selectedSubjectKey);
  static Future<void> setSelectedSubject(String subject) =>
      _prefs.setString(_selectedSubjectKey, subject);
}
