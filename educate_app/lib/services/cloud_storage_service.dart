import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class CloudStorageService {
  static final _supabase = Supabase.instance.client;
  static String? get _uid => AuthService.userId;

  static Future<void> saveQuizResult({
    required String title,
    required int totalQuestions,
    required int correctAnswers,
    required int timeSpentSeconds,
    required List<bool> answers,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final profile = await _supabase.from('profiles').select('total_quizzes, total_questions').eq('id', uid).single();
    final currentQuizzes = (profile as Map<String, dynamic>)['total_quizzes'] as int;
    final currentQuestions = profile['total_questions'] as int;

    await _supabase.from('quiz_results').insert({
      'user_id': uid,
      'title': title,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'time_spent_seconds': timeSpentSeconds,
      'answers': answers,
    });

    await _supabase.from('profiles').update({
      'total_quizzes': currentQuizzes + 1,
      'total_questions': currentQuestions + totalQuestions,
    }).eq('id', uid);
  }

  static Future<List<Map<String, dynamic>>> getQuizResults({int limit = 20}) async {
    final uid = _uid;
    if (uid == null) return [];
    final response = await _supabase
        .from('quiz_results')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(limit);
    return (response as List).cast<Map<String, dynamic>>();
  }

  static Stream<List<Map<String, dynamic>>> getQuizResultsStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _supabase
        .from('quiz_results')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .map((data) => data.map((e) => e.cast<String, dynamic>()).toList());
  }

  static Future<void> logStudyDay() async {
    final uid = _uid;
    if (uid == null) return;
    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await _supabase.from('study_days').upsert({
      'user_id': uid,
      'study_date': dateStr,
     }, onConflict: 'user_id,study_date');
  }

  static Future<List<Map<String, dynamic>>> getStudyDays({int lastDays = 30}) async {
    final uid = _uid;
    if (uid == null) return [];
    final startDate = DateTime.now().subtract(Duration(days: lastDays));
    final dateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final response = await _supabase
        .from('study_days')
        .select()
        .eq('user_id', uid)
        .gte('study_date', dateStr)
        .order('study_date', ascending: false);
    return (response as List).cast<Map<String, dynamic>>();
  }

  static Future<void> saveFlashcardProgress(List<String> masteredIds) async {
    final uid = _uid;
    if (uid == null) return;
    for (final cardId in masteredIds) {
      await _supabase.from('flashcard_progress').upsert({
        'user_id': uid,
        'flashcard_id': cardId,
        'mastered_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,flashcard_id');
    }
  }

  static Future<List<String>> getMasteredFlashcards() async {
    final uid = _uid;
    if (uid == null) return [];
    final response = await _supabase
        .from('flashcard_progress')
        .select('flashcard_id')
        .eq('user_id', uid);
    return (response as List).map((e) => e['flashcard_id'] as String).toList();
  }

  static Future<void> addXP(int amount) async {
    final uid = _uid;
    if (uid == null) return;
    final profile = await _supabase.from('profiles').select('xp').eq('id', uid).single();
    final current = (profile as Map<String, dynamic>)['xp'] as int;
    await _supabase.from('profiles').update({'xp': current + amount}).eq('id', uid);
  }

  static Future<void> updateStreak(int streak) async {
    final uid = _uid;
    if (uid == null) return;
    await _supabase.from('profiles').update({'streak': streak}).eq('id', uid);
  }

  static Future<void> addStudyMinutes(int minutes) async {
    final uid = _uid;
    if (uid == null) return;
    final profile = await _supabase.from('profiles').select('study_minutes').eq('id', uid).single();
    final current = (profile as Map<String, dynamic>)['study_minutes'] as int;
    await _supabase.from('profiles').update({'study_minutes': current + minutes}).eq('id', uid);
  }

  static Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 20}) async {
    final response = await _supabase
        .from('profiles')
        .select('name, xp, streak, total_quizzes, total_questions')
        .order('xp', ascending: false)
        .limit(limit);
    return (response as List).cast<Map<String, dynamic>>();
  }
}
