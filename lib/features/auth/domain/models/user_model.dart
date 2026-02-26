import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    String? displayName,
    String? username,
    String? avatarUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  /// Gösterim için isim: displayName doluysa o, değilse username veya email.
  String get displayNameOrUsername {
    final name = (displayName ?? '').trim();
    if (name.isNotEmpty) return name;
    return (username ?? '').trim().isNotEmpty ? username! : email;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
