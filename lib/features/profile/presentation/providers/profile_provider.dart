import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:notidea/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';
import 'package:notidea/features/profile/domain/repositories/profile_repository.dart';

part 'profile_provider.g.dart';

@riverpod
ProfileRemoteDatasource profileRemoteDatasource(
    ProfileRemoteDatasourceRef ref) {
  return ProfileRemoteDatasource();
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  final datasource = ref.watch(profileRemoteDatasourceProvider);
  return ProfileRepositoryImpl(remoteDatasource: datasource);
}

@riverpod
Future<ProfileModel?> currentProfile(CurrentProfileRef ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return null;

  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfileById(currentUser.id);
}

@riverpod
Future<ProfileModel?> profileById(ProfileByIdRef ref, String userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfileById(userId);
}

@riverpod
class UpdateProfile extends _$UpdateProfile {
  @override
  FutureOr<void> build() {}

  Future<ProfileModel?> execute(ProfileModel profile) async {
    ProfileModel? updated;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      updated = await repository.updateProfile(profile);
      ref.invalidate(currentProfileProvider);
      ref.invalidate(profileByIdProvider(profile.id));
    });
    return updated;
  }
}

@riverpod
class UploadAvatar extends _$UploadAvatar {
  @override
  FutureOr<void> build() {}

  Future<String?> execute({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    String? url;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      url = await repository.uploadAvatar(
        userId: userId,
        bytes: bytes,
        fileExtension: fileExtension,
      );
      ref.invalidate(currentProfileProvider);
      ref.invalidate(profileByIdProvider(userId));
    });
    return url;
  }
}

@riverpod
class DeleteAccount extends _$DeleteAccount {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      await repository.deleteAccount(userId);
    });
  }
}
