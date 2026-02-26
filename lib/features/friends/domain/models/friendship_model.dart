import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notidea/features/friends/domain/models/friendship_status.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

part 'friendship_model.freezed.dart';
part 'friendship_model.g.dart';

@freezed
sealed class FriendshipModel with _$FriendshipModel {
  const factory FriendshipModel({
    required String id,
    @JsonKey(name: 'requester_id') required String requesterId,
    @JsonKey(name: 'addressee_id') required String addresseeId,
    @Default(FriendshipStatus.pending) FriendshipStatus status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'requester_profile') ProfileModel? requesterProfile,
    @JsonKey(name: 'addressee_profile') ProfileModel? addresseeProfile,
  }) = _FriendshipModel;

  factory FriendshipModel.fromJson(Map<String, dynamic> json) =>
      _$FriendshipModelFromJson(json);
}
