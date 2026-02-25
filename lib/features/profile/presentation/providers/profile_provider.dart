import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:notidea/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';
import 'package:notidea/features/profile/domain/repositories/profile_repository.dart';
import 'package:notidea/core/database/app_database.dart';

part 'profile_provider.g.dart';

@riverpod
ProfileRemoteDatasource profileRemoteDatasource(Ref ref) {
  return ProfileRemoteDatasource();
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final datasource = ref.watch(profileRemoteDatasourceProvider);
  return ProfileRepositoryImpl(remoteDatasource: datasource);
}

@riverpod
Stream<ProfileModel?> currentProfile(Ref ref) async* {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) {
    yield null;
    return;
  }

  final repository = ref.watch(profileRepositoryProvider);
  final db = AppDatabase.instance;

  final local = db.getProfileById(currentUser.id);
  if (local != null) {
    yield local;
  }

  try {
    final remote = await repository.getProfileById(currentUser.id);
    if (remote != null) {
      await db.cacheProfile(remote);
      yield remote;
    } else if (local == null) {
      yield null;
    }
  } catch (e) {
    if (local == null) rethrow; // rethrow only if no local data
  }
}

@riverpod
Stream<ProfileModel?> profileById(Ref ref, String userId) async* {
  final repository = ref.watch(profileRepositoryProvider);
  final db = AppDatabase.instance;

  final local = db.getProfileById(userId);
  if (local != null) {
    yield local;
  }

  try {
    final remote = await repository.getProfileById(userId);
    if (remote != null) {
      await db.cacheProfile(remote);
      yield remote;
    } else if (local == null) {
      yield null;
    }
  } catch (e) {
    if (local == null) rethrow;
  }
}

@Riverpod(keepAlive: true)
class CreateProfile extends _$CreateProfile {
  @override
  FutureOr<void> build() {}

  Future<void> execute(ProfileModel profile) async {
    final repository = ref.read(profileRepositoryProvider);
    await repository.createProfile(profile);
    await AppDatabase.instance.cacheProfile(profile);
    ref.invalidate(currentProfileProvider);
  }
}

@Riverpod(keepAlive: true)
class UpdateProfile extends _$UpdateProfile {
  @override
  FutureOr<void> build() {}

  Future<ProfileModel> execute(ProfileModel profile) async {
    final repository = ref.read(profileRepositoryProvider);
    final updated = await repository.updateProfile(profile);
    await AppDatabase.instance.cacheProfile(updated);
    ref.invalidate(currentProfileProvider);
    ref.invalidate(profileByIdProvider(profile.id));
    return updated;
  }
}

@Riverpod(keepAlive: true)
class UploadAvatar extends _$UploadAvatar {
  @override
  FutureOr<void> build() {}

  Future<String> execute({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final repository = ref.read(profileRepositoryProvider);
    final url = await repository.uploadAvatar(
      userId: userId,
      bytes: bytes,
      fileExtension: fileExtension,
    );
    ref.invalidate(currentProfileProvider);
    ref.invalidate(profileByIdProvider(userId));
    return url;
  }
}

@Riverpod(keepAlive: true)
class DeleteAccount extends _$DeleteAccount {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String userId) async {
    final repository = ref.read(profileRepositoryProvider);
    await repository.deleteAccount(userId);
  }
}
