import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notidea/features/groups/domain/models/group_member_role.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

part 'group_member_model.freezed.dart';
part 'group_member_model.g.dart';

@freezed
sealed class GroupMemberModel with _$GroupMemberModel {
  const factory GroupMemberModel({
    required String id,
    required String groupId,
    required String userId,
    @Default(GroupMemberRole.member) GroupMemberRole role,
    required DateTime joinedAt,
    ProfileModel? profile,
  }) = _GroupMemberModel;

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);
}
