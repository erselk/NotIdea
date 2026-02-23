import 'package:notidea/features/auth/domain/models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> authStateChanges();
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
    required String username,
  });
  Future<void> signOut();
  Future<void> resetPassword({required String email});
}
