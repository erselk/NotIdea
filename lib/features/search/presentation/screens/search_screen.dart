import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/router/route_names.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';
import 'package:notidea/features/search/presentation/providers/search_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late final TabController _tabController;
  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.notesTab),
            Tab(text: l10n.usersTab),
            Tab(text: l10n.publicTab),
          ],
        ),
      ),
      body: _query.isEmpty
          ? _EmptySearchState(appColors: appColors)
          : TabBarView(
              controller: _tabController,
              children: [
                _NotesSearchTab(query: _query),
                _UsersSearchTab(query: _query),
                _PublicNotesSearchTab(query: _query),
              ],
            ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.appColors});

  final AppColorsExtension appColors;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 72,
              color: appColors.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.searchHint,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesSearchTab extends ConsumerWidget {
  const _NotesSearchTab({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final notesAsync = ref.watch(searchMyNotesProvider(query));

    return notesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (notes) {
        if (notes.isEmpty) {
          return _NoResultsWidget(appColors: appColors);
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: notes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (context, index) => _NoteResultCard(
            note: notes[index],
            query: query,
          ),
        );
      },
    );
  }
}

class _UsersSearchTab extends ConsumerWidget {
  const _UsersSearchTab({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final usersAsync = ref.watch(searchUsersGlobalProvider(query));

    return usersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (users) {
        if (users.isEmpty) {
          return _NoResultsWidget(appColors: appColors);
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: users.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            indent: 72,
            color: appColors.divider,
          ),
          itemBuilder: (context, index) => _UserResultTile(
            profile: users[index],
            query: query,
          ),
        );
      },
    );
  }
}

class _PublicNotesSearchTab extends ConsumerWidget {
  const _PublicNotesSearchTab({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final notesAsync = ref.watch(searchPublicNotesGlobalProvider(query));

    return notesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (notes) {
        if (notes.isEmpty) {
          return _NoResultsWidget(appColors: appColors);
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: notes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (context, index) => _NoteResultCard(
            note: notes[index],
            query: query,
          ),
        );
      },
    );
  }
}

class _NoteResultCard extends StatelessWidget {
  const _NoteResultCard({required this.note, required this.query});

  final NoteModel note;
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return Card(
      elevation: 0,
      color: appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: appColors.border.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/home/editor/${note.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HighlightText(
                text: note.title.isEmpty ? 'Untitled' : note.title,
                query: query,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appColors.textPrimary,
                ) ?? const TextStyle(),
                highlightColor: appColors.primary.withValues(alpha: 0.3),
                maxLines: 1,
              ),
              if (note.content.isNotEmpty) ...[
                const SizedBox(height: 4),
                _HighlightText(
                  text: note.content.length > 100
                      ? '${note.content.substring(0, 100)}...'
                      : note.content,
                  query: query,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: appColors.textSecondary,
                  ) ?? const TextStyle(),
                  highlightColor: appColors.primary.withValues(alpha: 0.2),
                  maxLines: 2,
                ),
              ],
              const SizedBox(height: 6),
              Text(
                timeago.format(note.updatedAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: appColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserResultTile extends StatelessWidget {
  const _UserResultTile({required this.profile, required this.query});

  final ProfileModel profile;
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return ListTile(
      onTap: () => context.pushNamed(
        RouteNames.userProfile,
        pathParameters: {'userId': profile.id},
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: appColors.surfaceVariant,
        backgroundImage: profile.avatarUrl != null
            ? CachedNetworkImageProvider(profile.avatarUrl!)
            : null,
        child: profile.avatarUrl == null
            ? Text(
                (profile.displayName ?? profile.username)[0].toUpperCase(),
                style: TextStyle(
                  color: appColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      ),
      title: _HighlightText(
        text: profile.displayName ?? profile.username,
        query: query,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: appColors.textPrimary,
        ) ?? const TextStyle(),
        highlightColor: appColors.primary.withValues(alpha: 0.3),
        maxLines: 1,
      ),
      subtitle: _HighlightText(
        text: '@${profile.username}',
        query: query,
        style: theme.textTheme.bodySmall?.copyWith(
          color: appColors.textSecondary,
        ) ?? const TextStyle(),
        highlightColor: appColors.primary.withValues(alpha: 0.2),
        maxLines: 1,
      ),
    );
  }
}

class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.text,
    required this.query,
    required this.style,
    required this.highlightColor,
    this.maxLines,
  });

  final String text;
  final String query;
  final TextStyle style;
  final Color highlightColor;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: style, maxLines: maxLines,
          overflow: TextOverflow.ellipsis);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(backgroundColor: highlightColor),
      ));
      start = index + query.length;
    }

    return RichText(
      text: TextSpan(style: style, children: spans),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _NoResultsWidget extends StatelessWidget {
  const _NoResultsWidget({required this.appColors});

  final AppColorsExtension appColors;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 56,
              color: appColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noSearchResults,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noSearchResultsDesc,
              style: theme.textTheme.bodySmall?.copyWith(
                color: appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
