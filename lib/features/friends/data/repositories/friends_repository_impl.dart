import 'package:notidea/features/friends/data/datasources/friends_remote_datasource.dart';
import 'package:notidea/features/friends/domain/models/friendship_model.dart';
import 'package:notidea/features/friends/domain/repositories/friends_repository.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsRemoteDatasource _remoteDatasource;

  FriendsRepositoryImpl({FriendsRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? FriendsRemoteDatasource();

  @override
  Future<List<FriendshipModel>> getFriends(String userId) {
    return _remoteDatasource.getFriends(userId);
  }

  @override
  Future<List<FriendshipModel>> getPendingRequests(String userId) {
    return _remoteDatasource.getPendingRequests(userId);
  }

  @override
  Future<FriendshipModel> sendRequest({
    required String requesterId,
    required String addresseeId,
  }) {
    return _remoteDatasource.sendRequest(
      requesterId: requesterId,
      addresseeId: addresseeId,
    );
  }

  @override
  Future<void> acceptRequest(String friendshipId) {
    return _remoteDatasource.acceptRequest(friendshipId);
  }

  @override
  Future<void> rejectRequest(String friendshipId) {
    return _remoteDatasource.rejectRequest(friendshipId);
  }

  @override
  Future<void> removeFriend(String friendshipId) {
    return _remoteDatasource.removeFriend(friendshipId);
  }

  @override
  Future<void> blockUser({
    required String userId,
    required String blockedUserId,
  }) {
    return _remoteDatasource.blockUser(
      userId: userId,
      blockedUserId: blockedUserId,
    );
  }

  @override
  Future<List<ProfileModel>> searchUsers({
    required String query,
    required String currentUserId,
    int limit = 20,
  }) {
    return _remoteDatasource.searchUsers(
      query: query,
      currentUserId: currentUserId,
      limit: limit,
    );
  }
}
