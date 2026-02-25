import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

part 'note_share_model.freezed.dart';
part 'note_share_model.g.dart';

enum SharePermission {
  @JsonValue('read_only')
  readOnly,
  @JsonValue('read_write')
  readWrite;
}

@freezed
sealed class NoteShareModel with _$NoteShareModel {
  const factory NoteShareModel({
    required String id,
    @JsonKey(name: 'note_id') required String noteId,
    @JsonKey(name: 'shared_by_user_id') required String sharedByUserId,
    @JsonKey(name: 'shared_with_user_id') String? sharedWithUserId,
    @JsonKey(name: 'shared_with_group_id') String? sharedWithGroupId,
    @JsonKey(name: 'share_token') String? shareToken,
    @Default(SharePermission.readOnly) SharePermission permission,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    NoteModel? note,
    @JsonKey(name: 'shared_by_profile') ProfileModel? sharedByProfile,
  }) = _NoteShareModel;

  factory NoteShareModel.fromJson(Map<String, dynamic> json) =>
      _$NoteShareModelFromJson(json);
}
