import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';

part 'explore_provider.g.dart';

enum ExploreSortMode { recent, trending }

@Riverpod(keepAlive: true)
class ExploreSortNotifier extends _$ExploreSortNotifier {
  @override
  ExploreSortMode build() => ExploreSortMode.recent;

  void setSort(ExploreSortMode mode) {
    state = mode;
  }
}

@riverpod
Future<List<NoteModel>> publicNotes(
  Ref ref, {
  int offset = 0,
  int limit = 30,
}) async {
  final sortMode = ref.watch(exploreSortProvider);
  final repository = ref.watch(notesRepositoryProvider);
  final notes = await repository.getPublicNotes(offset: offset, limit: limit);

  if (sortMode == ExploreSortMode.trending) {
    // Trending: son 7 gün içindeki notları güncelleme tarihine göre sırala
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    final recent = notes
        .where((n) => n.updatedAt.isAfter(oneWeekAgo))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final older = notes
        .where((n) => !n.updatedAt.isAfter(oneWeekAgo))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return [...recent, ...older];
  }

  // recent: oluşturulma tarihine göre (zaten sıralı geliyor)
  return notes;
}

@riverpod
Future<List<NoteModel>> searchPublicNotes(
  Ref ref,
  String query,
) async {
  if (query.trim().isEmpty) return [];

  final repository = ref.watch(notesRepositoryProvider);
  // Server-side ilike filtresi ile arama yap
  return repository.searchNotes(userId: '', query: query.trim(), limit: 50);
}
