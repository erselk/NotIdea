import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';
import 'package:notidea/features/notes/presentation/widgets/note_card.dart';
import 'package:notidea/shared/widgets/app_scaffold.dart';
import 'package:notidea/shared/widgets/branded_app_bar.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final favoritesAsync = ref.watch(favoriteNotesProvider);

    return Scaffold(
      appBar: BrandedAppBar(titleFirst: 'Fav', titleSecond: 'orites'),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(favoriteNotesProvider),
        child: favoritesAsync.when(
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
                  Text(error.toString(), style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => ref.invalidate(favoriteNotesProvider),
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
                        Icons.favorite_outline,
                        size: 72,
                        color: appColors.primary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noFavorites,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noFavoritesDesc,
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

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.favorite_border,
                        color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref
                        .read(toggleFavoriteProvider.notifier)
                        .execute(note.id, false);
                    ref.invalidate(favoriteNotesProvider);
                  },
                  child: NoteCard(
                    note: note,
                    onTap: () => context.push('/home/editor/${note.id}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
