import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/theme_extensions.dart';
import '../error/error_message_resolver.dart';

/// Uygulama genelinde tutarlı bildirim (SnackBar) gösterir.
/// Başarı / hata / bilgi tipleri, tema renkleri ve isteğe bağlı ikon kullanır.
class AppNotification {
  AppNotification._();

  /// Başarı mesajı (yeşil, check ikonu).
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      type: _NotificationType.success,
    );
  }

  /// Hata mesajı. [error] Object ise [ErrorMessageResolver] ile kullanıcı mesajına çevrilir.
  static void showError(BuildContext context, Object? error) {
    final String message = error is String
        ? error
        : ErrorMessageResolver.resolve(context, error);
    _show(
      context,
      message: message,
      type: _NotificationType.error,
    );
  }

  /// Bilgi mesajı (nötr renk, bilgi ikonu).
  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      type: _NotificationType.info,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required _NotificationType type,
  }) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    final Color backgroundColor;
    final Color foregroundColor;
    final IconData icon;

    switch (type) {
      case _NotificationType.success:
        backgroundColor = theme.colorScheme.primary;
        foregroundColor = theme.colorScheme.onPrimary;
        icon = Icons.check_circle_rounded;
        break;
      case _NotificationType.error:
        backgroundColor = theme.colorScheme.error;
        foregroundColor = theme.colorScheme.onError;
        icon = Icons.error_rounded;
        break;
      case _NotificationType.info:
        backgroundColor = appColors.surfaceVariant;
        foregroundColor = appColors.textPrimary;
        icon = Icons.info_outline_rounded;
        break;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: foregroundColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: foregroundColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: type == _NotificationType.error
            ? const Duration(seconds: 4)
            : const Duration(seconds: 3),
      ),
    );
  }
}

enum _NotificationType { success, error, info }
