import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';

enum NoteSortBy { createdAt, updatedAt, title }

enum NoteSortOrder { ascending, descending }

class NoteFilter {
  final bool? isFavorite;
  final NoteVisibility? visibility;
  final NoteSortBy sortBy;
  final NoteSortOrder sortOrder;
  final String? searchQuery;

  const NoteFilter({
    this.isFavorite,
    this.visibility,
    this.sortBy = NoteSortBy.updatedAt,
    this.sortOrder = NoteSortOrder.descending,
    this.searchQuery,
  });

  NoteFilter copyWith({
    bool? isFavorite,
    NoteVisibility? visibility,
    NoteSortBy? sortBy,
    NoteSortOrder? sortOrder,
    String? searchQuery,
  }) {
    return NoteFilter(
      isFavorite: isFavorite ?? this.isFavorite,
      visibility: visibility ?? this.visibility,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

abstract class NotesRepository {
  Future<List<NoteModel>> getUserNotes({
    required String userId,
    NoteFilter filter = const NoteFilter(),
    int offset = 0,
    int limit = 20,
  });

  Future<NoteModel?> getNoteById(String noteId);

  Future<NoteModel> createNote(NoteModel note);

  Future<NoteModel> updateNote(NoteModel note);

  Future<void> softDeleteNote(String noteId);

  Future<void> permanentlyDeleteNote(String noteId);

  Future<void> toggleFavorite(String noteId, bool isFavorite);

  Future<List<NoteModel>> searchNotes({
    required String userId,
    required String query,
    int limit = 50,
  });

  Future<List<NoteModel>> getPublicNotes({
    int offset = 0,
    int limit = 30,
  });

  Future<List<NoteModel>> getSharedNotes({
    required String userId,
    int offset = 0,
    int limit = 20,
  });
}
