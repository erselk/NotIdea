import 'package:freezed_annotation/freezed_annotation.dart';

enum GroupMemberRole {
  @JsonValue('owner')
  owner,
  @JsonValue('admin')
  admin,
  @JsonValue('member')
  member;

  String get value {
    switch (this) {
      case GroupMemberRole.owner:
        return 'owner';
      case GroupMemberRole.admin:
        return 'admin';
      case GroupMemberRole.member:
        return 'member';
    }
  }

  static GroupMemberRole fromValue(String value) {
    switch (value) {
      case 'owner':
        return GroupMemberRole.owner;
      case 'admin':
        return GroupMemberRole.admin;
      case 'member':
        return GroupMemberRole.member;
      default:
        return GroupMemberRole.member;
    }
  }
}
