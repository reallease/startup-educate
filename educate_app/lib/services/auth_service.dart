import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  // Session e User atual
  static Session? get currentSession => _supabase.auth.currentSession;
  static User? get currentUser => _supabase.auth.currentUser;
  static String? get userId => currentUser?.id;
  static Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // LOGIN COM EMAIL E SENHA
  static Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  // REGISTRO
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
    String? objective,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'name': name.trim(),
        'objective': objective ?? 'ENEM',
      },
    );

    // Criar perfil no banco apos registro (pelo trigger ou manualmente)
    if (response.user != null) {
      try {
        await _supabase.from('profiles').insert({
          'id': response.user!.id,
          'name': name.trim(),
          'email': email.trim(),
          'objective': objective ?? 'ENEM',
          'xp': 0,
          'streak': 1,
          'total_quizzes': 0,
          'total_questions': 0,
          'study_minutes': 0,
        });
      } catch (e) {
        // Se falhar, provavelmente o trigger ja criou ou a tabela nao existe
        debugPrint('Perfil insert: $e. Verificando se ja existe...');
        try {
          final existing =
              await _supabase.from('profiles').select('id').eq('id', response.user!.id);
          if ((existing as List).isEmpty) {
            // Tabela existe mas trigger nao - insercao manual
            await _supabase.from('profiles').upsert({
              'id': response.user!.id,
              'name': name.trim(),
              'email': email.trim(),
              'objective': objective ?? 'ENEM',
              'xp': 0,
              'streak': 1,
              'total_quizzes': 0,
              'total_questions': 0,
              'study_minutes': 0,
            }, onConflict: 'id');
          }
        } catch (_) {
          debugPrint('Tabela profiles nao existe. Rode o SQL migration primeiro!');
        }
      }
    }

    return response;
  }

  // LOGIN COM GOOGLE
  static Future<void> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(OAuthProvider.google);
  }

  // RECUPERAR SENHA
  static Future<void> sendPasswordReset(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: 'io.supabase.educate://reset-callback/',
    );
  }

  // UPDATE SENHA
  static Future<void> updatePassword(String password) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: password),
    );
  }

  // ATUALIZAR PERFIL
  static Future<void> updateProfile(Map<String, dynamic> data) async {
    final uid = userId;
    if (uid == null) return;
    await _supabase.from('profiles').update(data).eq('id', uid);
  }

  // BUSCAR DADOS DO USUARIO
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final uid = userId;
    if (uid == null) return null;
    final response = await _supabase.from('profiles').select().eq('id', uid).single();
    return response as Map<String, dynamic>;
  }

  // BUSCAR DADOS STREAM
  static Stream<List<Map<String, dynamic>>> getProfileStream() {
    final uid = userId;
    if (uid == null) return const Stream.empty();
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', uid)
        .map((data) => data.cast<Map<String, dynamic>>().toList());
  }

  // UPDATE AUTH USER (nome)
  static Future<void> updateAuthName(String name) async {
    await _supabase.auth.updateUser(
      UserAttributes(data: {'name': name.trim()}),
    );
  }

  // LOGOUT
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // DELETAR CONTA (remove dados e faz signOut, profile é cascade pela RLS)
  static Future<void> deleteAccount() async {
    final uid = userId;
    if (uid == null) return;
    // Tenta deletar dados relacionados
    try { await _supabase.from('quiz_results').delete().eq('user_id', uid); } catch (_) {}
    try { await _supabase.from('study_days').delete().eq('user_id', uid); } catch (_) {}
    try { await _supabase.from('flashcard_progress').delete().eq('user_id', uid); } catch (_) {}
    try { await _supabase.from('profiles').delete().eq('id', uid); } catch (_) {}
    await _supabase.auth.signOut();
  }
}
