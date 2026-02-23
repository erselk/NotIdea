import 'package:drift/drift.dart';
import 'package:notidea/core/database/app_database.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';

class NotesLocalDatasource {
  final AppDatabase _db = AppDatabase.instance;

  Future<void> cacheNotes(List<NoteModel> notes) async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.cachedNotes,
        notes.map(_toCompanion).toList(),
      );
    });
  }

  Future<void> cacheNote(NoteModel note) async {
    await _db.into(_db.cachedNotes).insertOnConflictUpdate(_toCompanion(note));
  }

  Future<List<NoteModel>> getCachedNotes(String userId) async {
    final rows = await (_db.select(_db.cachedNotes)
          ..where((t) => t.userId.equals(userId) & t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<NoteModel?> getCachedNoteById(String noteId) async {
    final row = await (_db.select(_db.cachedNotes)
          ..where((t) => t.id.equals(noteId)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<List<NoteModel>> searchCachedNotes({
    required String userId,
    required String query,
  }) async {
    final pattern = '%$query%';
    final rows = await (_db.select(_db.cachedNotes)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.isDeleted.equals(false) &
                (t.title.like(pattern) | t.content.like(pattern)),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<void> deleteCachedNote(String noteId) async {
    await (_db.delete(_db.cachedNotes)
          ..where((t) => t.id.equals(noteId)))
        .go();
  }

  Future<void> clearCache() async {
    await _db.delete(_db.cachedNotes).go();
  }

  // ── Search History ──

  Future<List<String>> getRecentSearches({int limit = 10}) async {
    final rows = await (_db.select(_db.searchHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.searchedAt)])
          ..limit(limit))
        .get();
    return rows.map((r) => r.query).toList();
  }

  Future<void> addSearchQuery(String query) async {
    await _db.into(_db.searchHistory).insert(
          SearchHistoryCompanion.insert(
            query: query,
            searchedAt: DateTime.now(),
          ),
        );
  }

  Future<void> clearSearchHistory() async {
    await _db.delete(_db.searchHistory).go();
  }

  // ── Mappers ──

  CachedNotesCompanion _toCompanion(NoteModel note) {
    return CachedNotesCompanion.insert(
      id: note.id,
      userId: note.userId,
      title: note.title,
      content: Value(note.content),
      color: Value(note.color),
      visibility: Value(note.visibility.value),
      isFavorite: Value(note.isFavorite),
      isDeleted: Value(note.isDeleted),
      deletedAt: Value(note.deletedAt),
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      tags: Value(note.tags?.join(',') ?? ''),
      imageUrls: Value(note.imageUrls?.join(',') ?? ''),
    );
  }

  NoteModel _fromRow(CachedNote row) {
    return NoteModel(
      id: row.id,
      userId: row.userId,
      title: row.title,
      content: row.content,
      color: row.color,
      visibility: NoteVisibility.values.firstWhere(
        (v) => v.value == row.visibility,
        orElse: () => NoteVisibility.private_,
      ),
      isFavorite: row.isFavorite,
      isDeleted: row.isDeleted,
      deletedAt: row.deletedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      tags: row.tags.isEmpty ? [] : row.tags.split(','),
      imageUrls: row.imageUrls.isEmpty ? [] : row.imageUrls.split(','),
    );
  }
}
