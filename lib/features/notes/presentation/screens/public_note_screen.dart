import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/core/router/route_names.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';

class PublicNoteScreen extends ConsumerWidget {
  final String noteId;

  const PublicNoteScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(noteByIdProvider(noteId));
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.login);
            }
          },
        ),
        title: Text(
          l10n.appName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: appColors.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              final link = '${AppConstants.baseUrl}/n/$noteId';
              Clipboard.setData(ClipboardData(text: link));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.linkCopied)),
              );
            },
          ),
        ],
      ),
      body: noteAsync.when(
        data: (note) {
          if (note == null) {
            return _ErrorView(
              message: l10n.noteNotFound,
              icon: Icons.search_off_rounded,
            );
          }

          if (note.visibility != NoteVisibility.public_) {
            return _ErrorView(
              message: l10n.onlyYouCanSee,
              icon: Icons.lock_outline_rounded,
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (note.title.isNotEmpty) ...[
                        Text(
                          note.title,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: appColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      MarkdownBody(
                        data: note.content,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                          p: GoogleFonts.inter(
                            fontSize: 16,
                            height: 1.6,
                            color: appColors.textPrimary,
                          ),
                          h1: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: appColors.textPrimary,
                          ),
                          code: GoogleFonts.firaCode(
                            backgroundColor: appColors.surfaceVariant,
                            color: appColors.primary,
                            fontSize: 14,
                          ),
                          blockquote: GoogleFonts.inter(
                            fontStyle: FontStyle.italic,
                            color: appColors.textSecondary,
                            decoration: TextDecoration.none,
                          ),
                          blockquoteDecoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: appColors.primary, width: 4),
                            ),
                            color: appColors.primary.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
              _buildCTA(context, appColors, l10n),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _ErrorView(
          message: err.toString(),
          icon: Icons.error_outline_rounded,
        ),
      ),
    );
  }

  Widget _buildCTA(BuildContext context, AppColorsExtension appColors, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: appColors.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.appTagline,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: appColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Box(
              style: Style(
                $box.width(double.infinity),
                $box.height(52),
                $box.decoration.borderRadius(12),
                $box.decoration.color(appColors.primary),
              ),
              child: PressableBox(
                onPress: () => context.go(RoutePaths.signup),
                child: Center(
                  child: Text(
                    l10n.signupWithEmail,
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final IconData icon;

  const _ErrorView({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Icon(icon, size: 64, color: appColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () => context.go(RoutePaths.login),
            icon: const Icon(Icons.login),
            label: Text(AppLocalizations.of(context)!.login),
          ),
          ],
        ),
      ),
    );
  }
}
