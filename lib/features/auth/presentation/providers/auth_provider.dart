import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notidea/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:notidea/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:notidea/features/auth/domain/models/user_model.dart';
import 'package:notidea/features/auth/domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRemoteDatasource authRemoteDatasource(Ref ref) {
  return AuthRemoteDatasource();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final datasource = ref.watch(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(remoteDatasource: datasource);
}

@riverpod
Stream<UserModel?> authState(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
}

@riverpod
Future<UserModel?> currentUser(Ref ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getCurrentUser();
}

@riverpod
class Login extends _$Login {
  @override
  FutureOr<void> build() {}

  Future<void> execute({
    required String email,
    required String password,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    await repository.signIn(email: email, password: password);
    ref.invalidate(currentUserProvider);
  }
}

@riverpod
class Signup extends _$Signup {
  @override
  FutureOr<void> build() {}

  Future<void> execute({
    required String email,
    required String password,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    await repository.signUp(email: email, password: password);
    ref.invalidate(currentUserProvider);
  }
}

@riverpod
class Logout extends _$Logout {
  @override
  FutureOr<void> build() {}

  Future<void> execute() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.signOut();
    ref.invalidate(currentUserProvider);
  }
}

@riverpod
class ResetPassword extends _$ResetPassword {
  @override
  FutureOr<void> build() {}

  Future<void> execute({required String email}) async {
    final repository = ref.read(authRepositoryProvider);
    await repository.resetPassword(email: email);
  }
}
