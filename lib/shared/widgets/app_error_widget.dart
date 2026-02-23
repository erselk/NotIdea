import 'package:flutter/material.dart';
import 'package:notidea/l10n/app_localizations.dart';

import 'package:notidea/core/theme/theme_extensions.dart';

/// Displays an error state with icon, message, and retry button.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.message,
    this.onRetry,
    this.fullPage = true,
    this.icon,
  });

  final String? message;
  final VoidCallback? onRetry;
  final bool fullPage;
  final IconData? icon;

  /// Compact inline variant for use within lists or cards.
  const AppErrorWidget.inline({
    super.key,
    this.message,
    this.onRetry,
    this.icon,
  }) : fullPage = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final appColors = theme.extension<AppColorsExtension>()!;
    final displayMessage = message ?? l10n.errorGeneral;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (fullPage) ...[
          Icon(
            icon ?? Icons.error_outline_rounded,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
        ] else ...[
          Icon(
            icon ?? Icons.error_outline_rounded,
            size: 32,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 8),
        ],
        Text(
          displayMessage,
          style: fullPage
              ? theme.textTheme.bodyLarge?.copyWith(color: appColors.textSecondary)
              : theme.textTheme.bodyMedium?.copyWith(color: appColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        if (onRetry != null) ...[
          SizedBox(height: fullPage ? 24 : 12),
          fullPage
              ? ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(l10n.retry),
                )
              : TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(l10n.retry),
                ),
        ],
      ],
    );

    if (!fullPage) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: content,
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: content,
      ),
    );
  }
}
