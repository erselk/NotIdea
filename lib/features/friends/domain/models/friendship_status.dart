import 'package:freezed_annotation/freezed_annotation.dart';

enum FriendshipStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
  @JsonValue('blocked')
  blocked;

  String get value {
    switch (this) {
      case FriendshipStatus.pending:
        return 'pending';
      case FriendshipStatus.accepted:
        return 'accepted';
      case FriendshipStatus.rejected:
        return 'rejected';
      case FriendshipStatus.blocked:
        return 'blocked';
    }
  }

  static FriendshipStatus fromValue(String value) {
    switch (value) {
      case 'pending':
        return FriendshipStatus.pending;
      case 'accepted':
        return FriendshipStatus.accepted;
      case 'rejected':
        return FriendshipStatus.rejected;
      case 'blocked':
        return FriendshipStatus.blocked;
      default:
        return FriendshipStatus.pending;
    }
  }
}
