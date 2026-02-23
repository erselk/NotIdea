import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
sealed class NoteModel with _$NoteModel {
  const factory NoteModel({
    required String id,
    required String userId,
    required String title,
    required String content,
    String? color,
    @Default(NoteVisibility.private_) NoteVisibility visibility,
    @Default(false) bool isFavorite,
    @Default(false) bool isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<String> tags,
    @Default([]) List<String> imageUrls,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}
