import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';

part 'explore_provider.g.dart';

enum ExploreSortMode { recent, trending }

@riverpod
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
  ref.watch(exploreSortProvider);
  final repository = ref.watch(notesRepositoryProvider);
  return repository.getPublicNotes(offset: offset, limit: limit);
}

@riverpod
Future<List<NoteModel>> searchPublicNotes(
  Ref ref,
  String query,
) async {
  if (query.trim().isEmpty) return [];

  final repository = ref.watch(notesRepositoryProvider);
  final allPublic = await repository.getPublicNotes(limit: 100);
  final lowerQuery = query.toLowerCase();

  return allPublic
      .where(
        (note) =>
            note.title.toLowerCase().contains(lowerQuery) ||
            note.content.toLowerCase().contains(lowerQuery),
      )
      .toList();
}
