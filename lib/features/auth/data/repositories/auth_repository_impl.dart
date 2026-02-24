import 'package:notidea/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:notidea/features/auth/domain/models/user_model.dart';
import 'package:notidea/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl({AuthRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? AuthRemoteDatasource();

  @override
  Stream<UserModel?> authStateChanges() {
    return _remoteDatasource.authStateChanges();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _remoteDatasource.getCurrentUser();
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    return _remoteDatasource.signIn(email: email, password: password);
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    return _remoteDatasource.signUp(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _remoteDatasource.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _remoteDatasource.resetPassword(email: email);
  }
}
