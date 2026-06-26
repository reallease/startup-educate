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
  static const _goalMinutesKey = 'goal_minutes';
  static const _goalQuestionsKey = 'goal_questions';
  static const _todayKey = 'today_date';
  static const _todayQuestionsKey = 'today_questions';
  static const _todayMinutesKey = 'today_minutes';
  static const _masteredCardsKey = 'mastered_cards';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---- Metas diárias ----
  static int getGoalMinutes() => _prefs.getInt(_goalMinutesKey) ?? 60;
  static Future<void> setGoalMinutes(int v) => _prefs.setInt(_goalMinutesKey, v);

  static int getGoalQuestions() => _prefs.getInt(_goalQuestionsKey) ?? 20;
  static Future<void> setGoalQuestions(int v) => _prefs.setInt(_goalQuestionsKey, v);

  static String _todayStr() {
    final t = DateTime.now();
    return '${t.year}-${t.month}-${t.day}';
  }

  /// Zera os contadores do dia se a última atividade foi em outro dia.
  static void _rolloverIfNeeded() {
    if (_prefs.getString(_todayKey) != _todayStr()) {
      _prefs.setString(_todayKey, _todayStr());
      _prefs.setInt(_todayQuestionsKey, 0);
      _prefs.setInt(_todayMinutesKey, 0);
    }
  }

  static int getTodayQuestions() {
    _rolloverIfNeeded();
    return _prefs.getInt(_todayQuestionsKey) ?? 0;
  }

  static int getTodayMinutes() {
    _rolloverIfNeeded();
    return _prefs.getInt(_todayMinutesKey) ?? 0;
  }

  // ---- Flashcards dominados (persistência local) ----
  static List<String> getMasteredCards() => _prefs.getStringList(_masteredCardsKey) ?? [];

  static Future<void> setCardMastered(String id, bool mastered) async {
    final set = getMasteredCards().toSet();
    if (mastered) {
      set.add(id);
    } else {
      set.remove(id);
    }
    await _prefs.setStringList(_masteredCardsKey, set.toList());
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
    _rolloverIfNeeded();
    await _prefs.setInt(_todayQuestionsKey, (_prefs.getInt(_todayQuestionsKey) ?? 0) + count);
    await recordStudyDay();
  }

  static int getStudyMinutes() => _prefs.getInt(_studyMinutesKey) ?? 0;

  static Future<void> addStudyMinutes(int minutes) async {
    await _prefs.setInt(_studyMinutesKey, (_prefs.getInt(_studyMinutesKey) ?? 0) + minutes);
    _rolloverIfNeeded();
    await _prefs.setInt(_todayMinutesKey, (_prefs.getInt(_todayMinutesKey) ?? 0) + minutes);
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
    if (result.timeSpentSeconds >= 60) {
      await addStudyMinutes(result.timeSpentSeconds ~/ 60);
    }
  }

  static String? getSelectedSubject() => _prefs.getString(_selectedSubjectKey);
  static Future<void> setSelectedSubject(String subject) =>
      _prefs.setString(_selectedSubjectKey, subject);
}
