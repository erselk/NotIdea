import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notidea/features/friends/domain/models/friendship_status.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

part 'friendship_model.freezed.dart';
part 'friendship_model.g.dart';

@freezed
sealed class FriendshipModel with _$FriendshipModel {
  const factory FriendshipModel({
    required String id,
    required String requesterId,
    required String addresseeId,
    @Default(FriendshipStatus.pending) FriendshipStatus status,
    required DateTime createdAt,
    DateTime? updatedAt,
    ProfileModel? requesterProfile,
    ProfileModel? addresseeProfile,
  }) = _FriendshipModel;

  factory FriendshipModel.fromJson(Map<String, dynamic> json) =>
      _$FriendshipModelFromJson(json);
}
