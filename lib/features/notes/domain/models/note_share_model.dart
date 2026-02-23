import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

part 'note_share_model.freezed.dart';
part 'note_share_model.g.dart';

@freezed
sealed class NoteShareModel with _$NoteShareModel {
  const factory NoteShareModel({
    required String id,
    required String noteId,
    required String sharedByUserId,
    String? sharedWithUserId,
    String? sharedWithGroupId,
    required DateTime createdAt,
    NoteModel? note,
    ProfileModel? sharedByProfile,
  }) = _NoteShareModel;

  factory NoteShareModel.fromJson(Map<String, dynamic> json) =>
      _$NoteShareModelFromJson(json);
}
