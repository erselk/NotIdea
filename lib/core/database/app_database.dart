import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const String _notesBox = 'notes_cache';
  static const String _profilesBox = 'profiles_cache';
  static const String _searchBox = 'search_history';
  static const String _prefsBox = 'app_prefs';

  late Box<Map> _notes;
  late Box<Map> _profiles;
  late Box<List> _search;
  late Box _prefs;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    _notes = await Hive.openBox<Map>(_notesBox);
    _profiles = await Hive.openBox<Map>(_profilesBox);
    _search = await Hive.openBox<List>(_searchBox);
    _prefs = await Hive.openBox(_prefsBox);

    _initialized = true;
    debugPrint('Hive: initialized with ${_notes.length} cached notes');
  }

  // ── Notes ──

  Future<void> cacheNote(NoteModel note) async {
    await _notes.put(note.id, note.toJson());
  }

  Future<void> cacheNotes(List<NoteModel> notes) async {
    final entries = <String, Map>{
      for (final note in notes) note.id: note.toJson(),
    };
    await _notes.putAll(entries);
  }

  NoteModel? getNoteById(String id) {
    final raw = _notes.get(id);
    if (raw == null) return null;
    return NoteModel.fromJson(Map<String, dynamic>.from(raw));
  }

  List<NoteModel> getNotesByUserId(String userId) {
    return _notes.values
        .map((raw) => NoteModel.fromJson(Map<String, dynamic>.from(raw)))
        .where((n) => n.userId == userId && !n.isDeleted)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  List<NoteModel> getAllCachedNotes() {
    return _notes.values
        .map((raw) => NoteModel.fromJson(Map<String, dynamic>.from(raw)))
        .toList();
  }

  List<NoteModel> searchNotes(String userId, String query) {
    final q = query.toLowerCase();
    return _notes.values
        .map((raw) => NoteModel.fromJson(Map<String, dynamic>.from(raw)))
        .where(
          (n) =>
              n.userId == userId &&
              !n.isDeleted &&
              (n.title.toLowerCase().contains(q) ||
                  n.content.toLowerCase().contains(q) ||
                  n.tags.any((t) => t.toLowerCase().contains(q))),
        )
        .toList();
  }

  Future<void> deleteNote(String id) async {
    await _notes.delete(id);
  }

  Future<void> clearNotesCache() async {
    await _notes.clear();
  }

  // ── Profiles ──

  Future<void> cacheProfile(ProfileModel profile) async {
    await _profiles.put(profile.id, profile.toJson());
  }

  ProfileModel? getProfileById(String id) {
    final raw = _profiles.get(id);
    if (raw == null) return null;
    return ProfileModel.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<void> clearProfilesCache() async {
    await _profiles.clear();
  }

  // ── Search History ──

  List<String> getRecentSearches({int limit = 10}) {
    final history = _search.get('history')?.cast<String>() ?? <String>[];
    return history.reversed.take(limit).toList();
  }

  Future<void> addSearch(String query) async {
    final history = _search.get('history')?.cast<String>() ?? <String>[];
    history.remove(query);
    history.add(query);
    if (history.length > 50) history.removeRange(0, history.length - 50);
    await _search.put('history', history);
  }

  Future<void> clearSearchHistory() async {
    await _search.delete('history');
  }

  // ── Preferences ──

  T? getPref<T>(String key) => _prefs.get(key) as T?;
  Future<void> setPref<T>(String key, T value) => _prefs.put(key, value);

  // ── Lifecycle ──

  Future<void> clearAll() async {
    await _notes.clear();
    await _profiles.clear();
    await _search.clear();
  }

  Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}
