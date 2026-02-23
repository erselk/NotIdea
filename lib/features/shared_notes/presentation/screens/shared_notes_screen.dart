import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/features/shared_notes/presentation/providers/shared_notes_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class SharedNotesScreen extends ConsumerWidget {
  const SharedNotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final sharedAsync = ref.watch(sharedWithMeNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sharedNotes),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(sharedWithMeNotesProvider),
        child: sharedAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48,
                      color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text(error.toString()),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () =>
                        ref.invalidate(sharedWithMeNotesProvider),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          ),
          data: (shares) {
            if (shares.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.share_outlined,
                        size: 72,
                        color: appColors.primary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noSharedNotes,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noSharedNotesDesc,
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

            final directShares =
                shares.where((s) => s.sharedWithGroupId == null).toList();
            final groupShares =
                shares.where((s) => s.sharedWithGroupId != null).toList();

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                if (directShares.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      l10n.sharedWithMe,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ),
                  ...directShares.map((share) {
                    final note = share.note;
                    if (note == null) return const SizedBox.shrink();

                    final sharedBy = share.sharedByProfile;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      elevation: 0,
                      color: appColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: appColors.border.withValues(alpha: 0.3),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () =>
                            context.push('/home/note/${note.id}'),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title.isEmpty
                                    ? 'Untitled'
                                    : note.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (note.content.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  note.content.length > 100
                                      ? '${note.content.substring(0, 100)}...'
                                      : note.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      theme.textTheme.bodySmall?.copyWith(
                                    color: appColors.textSecondary,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  if (sharedBy != null) ...[
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor:
                                          appColors.surfaceVariant,
                                      backgroundImage:
                                          sharedBy.avatarUrl != null
                                              ? CachedNetworkImageProvider(
                                                  sharedBy.avatarUrl!)
                                              : null,
                                      child: sharedBy.avatarUrl == null
                                          ? Text(
                                              (sharedBy.displayName ??
                                                      sharedBy.username)[0]
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: appColors.primary,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        l10n.sharedByUser(
                                          sharedBy.displayName ??
                                              sharedBy.username,
                                        ),
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: appColors.textTertiary,
                                        ),
                                      ),
                                    ),
                                  ],
                                  Text(
                                    timeago.format(share.createdAt),
                                    style: theme.textTheme.labelSmall
                                        ?.copyWith(
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
                  }),
                ],
                if (groupShares.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      l10n.groupSharedNotes,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ),
                  ...groupShares.map((share) {
                    final note = share.note;
                    if (note == null) return const SizedBox.shrink();

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      elevation: 0,
                      color: appColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: appColors.border.withValues(alpha: 0.3),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () =>
                            context.push('/home/note/${note.id}'),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.group, size: 16,
                                      color: appColors.textTertiary),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      note.title.isEmpty
                                          ? 'Untitled'
                                          : note.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (note.content.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  note.content.length > 100
                                      ? '${note.content.substring(0, 100)}...'
                                      : note.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      theme.textTheme.bodySmall?.copyWith(
                                    color: appColors.textSecondary,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 6),
                              Text(
                                timeago.format(share.createdAt),
                                style:
                                    theme.textTheme.labelSmall?.copyWith(
                                  color: appColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
