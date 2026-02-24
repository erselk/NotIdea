import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/features/explore/presentation/providers/explore_provider.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/profile/presentation/providers/profile_provider.dart';
import 'package:notidea/shared/widgets/app_scaffold.dart';
import 'package:timeago/timeago.dart' as timeago;

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() => _searchQuery = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final sortMode = ref.watch(exploreSortNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: _isSearching
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => AppScaffold.openDrawer(context),
              ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  border: InputBorder.none,
                ),
              )
            : Text(l10n.explore),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          if (!_isSearching)
            PopupMenuButton<ExploreSortMode>(
              onSelected: (mode) =>
                  ref.read(exploreSortNotifierProvider.notifier).setSort(mode),
              icon: const Icon(Icons.sort),
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: ExploreSortMode.recent,
                  child: Row(
                    children: [
                      if (sortMode == ExploreSortMode.recent)
                        Icon(Icons.check, size: 18, color: appColors.primary),
                      if (sortMode == ExploreSortMode.recent)
                        const SizedBox(width: 8),
                      Text(l10n.recent),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: ExploreSortMode.trending,
                  child: Row(
                    children: [
                      if (sortMode == ExploreSortMode.trending)
                        Icon(Icons.check, size: 18, color: appColors.primary),
                      if (sortMode == ExploreSortMode.trending)
                        const SizedBox(width: 8),
                      Text(l10n.trending),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _searchQuery.isNotEmpty
          ? _SearchResultsView(query: _searchQuery)
          : _PublicNotesView(appColors: appColors),
    );
  }
}

class _PublicNotesView extends ConsumerWidget {
  const _PublicNotesView({required this.appColors});

  final AppColorsExtension appColors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final notesAsync = ref.watch(publicNotesProvider());

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(publicNotesProvider),
      child: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text(error.toString()),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => ref.invalidate(publicNotesProvider),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.explore_outlined,
                      size: 72,
                      color: appColors.primary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noExploreResults,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.noExploreResultsDesc,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: appColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _ExploreNoteCard(note: notes[index]);
            },
          );
        },
      ),
    );
  }
}

class _SearchResultsView extends ConsumerWidget {
  const _SearchResultsView({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final searchAsync = ref.watch(searchPublicNotesProvider(query));

    return searchAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (notes) {
        if (notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off, size: 56, color: appColors.textTertiary),
                const SizedBox(height: 16),
                Text(l10n.noSearchResults, style: theme.textTheme.titleMedium),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: notes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _ExploreNoteCard(note: notes[index]);
          },
        );
      },
    );
  }
}

class _ExploreNoteCard extends ConsumerWidget {
  const _ExploreNoteCard({required this.note});

  final NoteModel note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final authorAsync = ref.watch(profileByIdProvider(note.userId));

    final contentPreview = note.content.length > 150
        ? '${note.content.substring(0, 150)}...'
        : note.content;

    return Card(
      elevation: 0,
      color: appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: appColors.border.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/home/note/${note.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title.isEmpty ? 'Untitled' : note.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appColors.textPrimary,
                ),
              ),
              if (contentPreview.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  contentPreview,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: appColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  authorAsync.when(
                    loading: () => const SizedBox(width: 20, height: 20),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (profile) {
                      if (profile == null) return const SizedBox.shrink();
                      return GestureDetector(
                        onTap: () => context.push('/profile/user/${note.userId}'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: appColors.surfaceVariant,
                              backgroundImage: profile.avatarUrl != null
                                  ? CachedNetworkImageProvider(
                                      profile.avatarUrl!)
                                  : null,
                              child: profile.avatarUrl == null
                                  ? Text(
                                      (profile.displayName ?? profile.username)[0]
                                          .toUpperCase(),
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: appColors.primary,
                                        fontSize: 10,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              profile.displayName ?? profile.username,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: appColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Text(
                    timeago.format(note.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: appColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
