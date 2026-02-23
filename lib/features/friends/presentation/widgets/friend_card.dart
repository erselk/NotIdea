import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    super.key,
    required this.profile,
    this.trailing,
    this.onTap,
    this.subtitle,
  });

  final ProfileModel profile;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: appColors.surfaceVariant,
        backgroundImage: profile.avatarUrl != null
            ? CachedNetworkImageProvider(profile.avatarUrl!)
            : null,
        child: profile.avatarUrl == null
            ? Text(
                _getInitials(),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: appColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      ),
      title: Text(
        profile.displayName ?? profile.username,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: appColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle ?? '@${profile.username}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: appColors.textSecondary,
        ),
      ),
      trailing: trailing,
    );
  }

  String _getInitials() {
    final name = profile.displayName ?? profile.username;
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}
