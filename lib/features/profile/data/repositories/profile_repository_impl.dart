import 'dart:typed_data';
import 'package:notidea/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';
import 'package:notidea/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource _remoteDatasource;

  ProfileRepositoryImpl({ProfileRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? ProfileRemoteDatasource();

  @override
  Future<ProfileModel?> getProfileById(String userId) async {
    return _remoteDatasource.getProfileById(userId);
  }

  @override
  Future<bool> isUsernameTaken(String username, {String? excludeUserId}) async {
    return _remoteDatasource.isUsernameTaken(username, excludeUserId: excludeUserId);
  }

  @override
  Future<ProfileModel> createProfile(ProfileModel profile) async {
    return _remoteDatasource.createProfile(profile);
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    return _remoteDatasource.updateProfile(profile);
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    return _remoteDatasource.uploadAvatar(
      userId: userId,
      bytes: bytes,
      fileExtension: fileExtension,
    );
  }

  @override
  Future<void> deleteAccount(String userId) async {
    await _remoteDatasource.deleteAccount(userId);
  }
}
