import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/features/auth/domain/models/user_model.dart';

class AuthRemoteDatasource {
  final GoTrueClient _auth = SupabaseConfig.auth;
  final SupabaseClient _client = SupabaseConfig.client;

  Stream<UserModel?> authStateChanges() {
    return _auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return _mapUserWithCachedProfile(user);
    });
  }

  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _mapUserWithCachedProfile(user);
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
      throw Exception('Login failed: user not found');
    }

    return _mapUserWithProfile(user);
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      // APK deep link redirect — Supabase dashboard'unda izinli olmalı
      emailRedirectTo: AppConstants.authRedirectUrl,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Signup failed: could not create user');
    }

    return _mapUserWithCachedProfile(user);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _auth.resetPasswordForEmail(
      email,
      redirectTo: AppConstants.authRedirectUrl,
    );
  }

  Future<UserModel> signInWithGoogle() async {
    final redirectUrl =
        kIsWeb ? Uri.base.origin : AppConstants.authRedirectUrl;

    await _auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectUrl,
    );

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Login with Google failed: user not found');
    }

    return _mapUserWithProfile(user);
  }

  Future<UserModel> _mapUserWithProfile(User user) async {
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

  UserModel _mapUserWithCachedProfile(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }
}
