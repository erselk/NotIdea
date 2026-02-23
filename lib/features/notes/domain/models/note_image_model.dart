import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_image_model.freezed.dart';
part 'note_image_model.g.dart';

@freezed
sealed class NoteImageModel with _$NoteImageModel {
  const factory NoteImageModel({
    required String id,
    required String noteId,
    required String imageUrl,
    required String storagePath,
    int? width,
    int? height,
    int? sizeBytes,
    required DateTime createdAt,
  }) = _NoteImageModel;

  factory NoteImageModel.fromJson(Map<String, dynamic> json) =>
      _$NoteImageModelFromJson(json);
}
