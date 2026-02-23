import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
sealed class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String username,
    String? displayName,
    String? avatarUrl,
    String? bio,
    @Default(0) int noteCount,
    @Default(0) int friendCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
