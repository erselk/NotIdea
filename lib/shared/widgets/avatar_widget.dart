import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:notidea/core/theme/theme_extensions.dart';

/// Size presets for the avatar widget.
enum AvatarSize {
  small(32),
  medium(48),
  large(80),
  xlarge(120);

  const AvatarSize(this.value);
  final double value;
}

/// Circular avatar that shows a network image or falls back to initials.
class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AvatarSize.medium,
    this.showEditBadge = false,
    this.onEditTap,
    this.showBorder = false,
  });

  final String? imageUrl;
  final String? name;
  final AvatarSize size;
  final bool showEditBadge;
  final VoidCallback? onEditTap;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final diameter = size.value;
    final fontSize = diameter * 0.38;

    Widget avatar = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: appColors.border, width: 2)
            : null,
      ),
      child: ClipOval(
        child: _hasValidUrl
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                width: diameter,
                height: diameter,
                fit: BoxFit.cover,
                placeholder: (_, __) => _InitialsAvatar(
                  name: name,
                  fontSize: fontSize,
                  backgroundColor: appColors.primaryLight,
                  textColor: appColors.primary,
                ),
                errorWidget: (_, __, ___) => _InitialsAvatar(
                  name: name,
                  fontSize: fontSize,
                  backgroundColor: appColors.primaryLight,
                  textColor: appColors.primary,
                ),
              )
            : _InitialsAvatar(
                name: name,
                fontSize: fontSize,
                backgroundColor: appColors.primaryLight,
                textColor: appColors.primary,
              ),
      ),
    );

    if (!showEditBadge) return avatar;

    return Stack(
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              padding: EdgeInsets.all(diameter * 0.06),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: appColors.surface, width: 2),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: diameter * 0.2,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool get _hasValidUrl =>
      imageUrl != null && imageUrl!.isNotEmpty;
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({
    required this.name,
    required this.fontSize,
    required this.backgroundColor,
    required this.textColor,
  });

  final String? name;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: Text(
        _getInitials(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _getInitials() {
    if (name == null || name!.trim().isEmpty) return '?';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
