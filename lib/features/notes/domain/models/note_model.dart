import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
sealed class NoteModel with _$NoteModel {
  const factory NoteModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required String content,
    String? color,
    @Default(NoteVisibility.private_) NoteVisibility visibility,
    @Default(false) @JsonKey(name: 'is_favorite') bool isFavorite,
    @Default(false) @JsonKey(name: 'is_pinned') bool isPinned,
    @JsonKey(name: 'pinned_at') DateTime? pinnedAt,
    @Default(false) @JsonKey(name: 'is_deleted') bool isDeleted,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @Default([]) List<String> tags,
    @JsonKey(name: 'image_urls') @Default([]) List<String> imageUrls,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}
