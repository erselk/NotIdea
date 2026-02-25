import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/router/route_names.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/features/groups/presentation/providers/groups_provider.dart';
import 'package:notidea/shared/widgets/app_scaffold.dart';
import 'package:notidea/shared/widgets/branded_app_bar.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final groupsAsync = ref.watch(myGroupsProvider);

    return Scaffold(
      appBar: BrandedAppBar(titleFirst: 'Gr', titleSecond: 'oups'),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(myGroupsProvider),
        child: groupsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text(error.toString(), style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => ref.invalidate(myGroupsProvider),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          ),
          data: (groups) {
            if (groups.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.group_outlined,
                        size: 72,
                        color: appColors.primary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noGroups,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noGroupsDesc,
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
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: groups.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 72,
                color: appColors.divider,
              ),
              itemBuilder: (context, index) {
                final group = groups[index];
                return ListTile(
                  onTap: () => context.pushNamed(
                    RouteNames.groupDetail,
                    pathParameters: {'groupId': group.id},
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: appColors.primaryLight,
                    child: Icon(
                      Icons.group,
                      color: appColors.primary,
                    ),
                  ),
                  title: Text(
                    group.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: appColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    group.description ?? l10n.memberCount(group.memberCount),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: appColors.textSecondary,
                    ),
                  ),
                  trailing: Text(
                    l10n.memberCount(group.memberCount),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: appColors.textTertiary,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(RouteNames.createGroup),
        icon: const Icon(Icons.group_add),
        label: Text(l10n.createGroup),
      ),
    );
  }
}
