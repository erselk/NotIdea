import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/features/auth/domain/models/user_model.dart';

class AuthRemoteDatasource {
  final GoTrueClient _auth = SupabaseConfig.auth;
  final SupabaseClient _client = SupabaseConfig.client;

  Stream<UserModel?> authStateChanges() {
    return _auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        createdAt: DateTime.tryParse(user.createdAt),
      );
    });
  }

  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Giriş başarısız: kullanıcı bulunamadı');
    }

    final profile = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: profile?['display_name'] as String?,
      username: profile?['username'] as String?,
      avatarUrl: profile?['avatar_url'] as String?,
      bio: profile?['bio'] as String?,
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
    required String username,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Kayıt başarısız: kullanıcı oluşturulamadı');
    }

    await _client.from('profiles').insert({
      'id': user.id,
      'username': username,
      'display_name': displayName,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: displayName,
      username: username,
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _auth.resetPasswordForEmail(email);
  }
}
