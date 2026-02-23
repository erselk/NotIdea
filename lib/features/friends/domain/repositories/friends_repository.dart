import 'package:notidea/features/friends/domain/models/friendship_model.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

abstract class FriendsRepository {
  Future<List<FriendshipModel>> getFriends(String userId);

  Future<List<FriendshipModel>> getPendingRequests(String userId);

  Future<FriendshipModel> sendRequest({
    required String requesterId,
    required String addresseeId,
  });

  Future<void> acceptRequest(String friendshipId);

  Future<void> rejectRequest(String friendshipId);

  Future<void> removeFriend(String friendshipId);

  Future<void> blockUser({
    required String userId,
    required String blockedUserId,
  });

  Future<List<ProfileModel>> searchUsers({
    required String query,
    required String currentUserId,
    int limit = 20,
  });
}
