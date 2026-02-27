import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Uygulama genelinde hata nesnelerini kullanıcıya gösterilebilir metne çevirir.
/// Supabase (Auth, Postgrest), ağ ve genel hatalar için lokalize mesaj döndürür.
class ErrorMessageResolver {
  ErrorMessageResolver._();

  /// [error] null veya boşsa [errorGeneral] döner.
  /// [context] l10n için kullanılır.
  static String resolve(BuildContext context, Object? error) {
    final l10n = AppLocalizations.of(context)!;
    if (error == null) return l10n.errorGeneral;

    // Zaten kullanıcı mesajı
    if (error is String) {
      if (error.isEmpty) return l10n.errorGeneral;
      return _cleanRawMessage(error);
    }

    // Supabase Auth
    if (error is AuthException) {
      return _resolveAuthException(error, l10n);
    }

    // Postgrest / Exception message
    final message = _tryGetMessage(error);
    if (message != null && message.isNotEmpty) {
      final cleaned = _cleanRawMessage(message);
      if (_isUsernameTaken(cleaned)) return l10n.usernameTaken;
      if (_isNetworkError(cleaned)) return l10n.errorNetwork;
      if (_isTimeoutError(cleaned)) return l10n.errorTimeout;
      if (_isUnauthorized(cleaned)) return l10n.errorUnauthorized;
      if (_isNotFound(cleaned)) return l10n.errorNotFound;
      if (_isServerError(cleaned)) return l10n.errorServer;
      return cleaned;
    }

    if (error is TimeoutException) return l10n.errorTimeout;

    return l10n.errorGeneral;
  }

  static String _resolveAuthException(AuthException e, AppLocalizations l10n) {
    final msg = (e.message).trim().toLowerCase();
    if (msg.contains('invalid login') || msg.contains('invalid_credentials')) {
      return l10n.errorGeneral;
    }
    if (msg.contains('email not confirmed')) return l10n.errorGeneral;
    if (msg.contains('session') && msg.contains('expired')) return l10n.errorUnauthorized;
    if (e.message.isNotEmpty) return _cleanRawMessage(e.message);
    return l10n.errorGeneral;
  }

  static String? _tryGetMessage(Object error) {
    try {
      if (error is Exception && error.toString().isNotEmpty) {
        final s = error.toString();
        if (s.startsWith('Exception:')) return s.replaceFirst('Exception:', '').trim();
        return s;
      }
      // PostgrestException has message
      final dynamic e = error;
      if (e is Map && e['message'] != null) return e['message'].toString();
      return error.toString();
    } catch (_) {
      return null;
    }
  }

  static String _cleanRawMessage(String s) {
    s = s.trim();
    const prefixes = ['Exception:', 'Error:', 'AuthException:', 'PostgrestException:'];
    for (final p in prefixes) {
      if (s.toLowerCase().startsWith(p.toLowerCase())) {
        s = s.substring(p.length).trim();
        break;
      }
    }
    return s.isEmpty ? 'Something went wrong' : s;
  }

  static bool _isUsernameTaken(String s) =>
      s.toLowerCase().contains('username') && (s.toLowerCase().contains('taken') || s.toLowerCase().contains('already'));

  static bool _isNetworkError(String s) {
    final l = s.toLowerCase();
    return l.contains('socket') || l.contains('network') || l.contains('connection') || l.contains('internet');
  }

  static bool _isTimeoutError(String s) =>
      s.toLowerCase().contains('timeout') || s.toLowerCase().contains('timed out');

  static bool _isUnauthorized(String s) {
    final l = s.toLowerCase();
    return l.contains('unauthorized') || l.contains('401') || l.contains('session') || l.contains('jwt');
  }

  static bool _isNotFound(String s) {
    final l = s.toLowerCase();
    return l.contains('not found') || l.contains('404');
  }

  static bool _isServerError(String s) {
    final l = s.toLowerCase();
    return l.contains('500') || l.contains('502') || l.contains('503') || l.contains('server error');
  }
}
