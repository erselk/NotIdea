import 'dart:typed_data';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel?> getProfileById(String userId);
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
  });
  Future<void> deleteAccount(String userId);
}
