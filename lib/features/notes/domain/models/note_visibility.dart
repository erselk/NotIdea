import 'package:freezed_annotation/freezed_annotation.dart';

enum NoteVisibility {
  @JsonValue('public')
  public_,
  @JsonValue('private')
  private_,
  @JsonValue('friends')
  friends;

  String get value {
    switch (this) {
      case NoteVisibility.public_:
        return 'public';
      case NoteVisibility.private_:
        return 'private';
      case NoteVisibility.friends:
        return 'friends';
    }
  }

  static NoteVisibility fromValue(String value) {
    switch (value) {
      case 'public':
        return NoteVisibility.public_;
      case 'private':
        return NoteVisibility.private_;
      case 'friends':
        return NoteVisibility.friends;
      default:
        return NoteVisibility.private_;
    }
  }
}
