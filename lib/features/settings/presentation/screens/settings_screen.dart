import 'package:flutter/material.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notidea/core/l10n/l10n.dart';
import 'package:notidea/core/router/route_names.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/shared/providers/locale_provider.dart';
import 'package:notidea/shared/providers/theme_provider.dart';
import 'package:notidea/shared/widgets/confirm_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final currentThemeMode = ref.watch(themeModeNotifierProvider);
    final currentLocale = ref.watch(localeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // ─── Appearance ───
          _SectionHeader(title: l10n.appearance),
          _ThemeTile(
            currentMode: currentThemeMode,
            onChanged: (mode) {
              ref.read(themeModeNotifierProvider.notifier).setThemeMode(mode);
            },
          ),
          _LanguageTile(
            currentLocale: currentLocale,
            onChanged: (locale) {
              ref.read(localeNotifierProvider.notifier).setLocale(locale);
            },
          ),
          Divider(height: 1, color: appColors.divider),

          // ─── Account ───
          _SectionHeader(title: l10n.account),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: Text(l10n.editProfile),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.goNamed(RouteNames.editProfile),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded),
            title: Text(l10n.changePassword),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              // TODO: Navigate to change password flow
            },
          ),
          Divider(height: 1, color: appColors.divider),

          // ─── About ───
          _SectionHeader(title: l10n.aboutApp),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacyPolicy),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.goNamed(RouteNames.privacyPolicy),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.termsOfService),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.goNamed(RouteNames.termsOfService),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(l10n.version),
            subtitle: const Text('1.0.0 (1)'),
          ),
          Divider(height: 1, color: appColors.divider),

          // ─── Danger Zone ───
          _SectionHeader(
            title: l10n.dangerZone,
            isDanger: true,
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_rounded, color: theme.colorScheme.error),
            title: Text(
              l10n.deleteAccount,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () async {
              final confirmed = await showConfirmDialog(
                context,
                title: l10n.deleteAccount,
                message: l10n.deleteAccountConfirm,
                confirmLabel: l10n.delete,
                isDestructive: true,
              );
              if (confirmed && context.mounted) {
                // TODO: Implement account deletion
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
            title: Text(
              l10n.logout,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () async {
              final confirmed = await showConfirmDialog(
                context,
                title: l10n.logout,
                message: l10n.logoutConfirm,
                confirmLabel: l10n.logout,
                isDestructive: true,
              );
              if (confirmed && context.mounted) {
                // TODO: Implement logout
              }
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.isDanger = false});

  final String title;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: isDanger
              ? theme.colorScheme.error
              : theme.extension<AppColorsExtension>()!.textTertiary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.currentMode, required this.onChanged});

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    String subtitle = switch (currentMode) {
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
      ThemeMode.system => l10n.themeSystem,
    };

    return ListTile(
      leading: Icon(
        switch (currentMode) {
          ThemeMode.light => Icons.light_mode_rounded,
          ThemeMode.dark => Icons.dark_mode_rounded,
          ThemeMode.system => Icons.brightness_auto_rounded,
        },
      ),
      title: Text(l10n.theme),
      subtitle: Text(subtitle, style: TextStyle(color: appColors.textSecondary)),
      onTap: () => _showThemePicker(context),
    );
  }

  void _showThemePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.themeLight),
              secondary: const Icon(Icons.light_mode_rounded),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (v) {
                if (v != null) onChanged(v);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.themeDark),
              secondary: const Icon(Icons.dark_mode_rounded),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (v) {
                if (v != null) onChanged(v);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.themeSystem),
              secondary: const Icon(Icons.brightness_auto_rounded),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (v) {
                if (v != null) onChanged(v);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.currentLocale, required this.onChanged});

  final Locale currentLocale;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return ListTile(
      leading: const Icon(Icons.language_rounded),
      title: Text(l10n.language),
      subtitle: Text(
        L10n.getLanguageName(currentLocale.languageCode),
        style: TextStyle(color: appColors.textSecondary),
      ),
      onTap: () => _showLanguagePicker(context),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: L10n.supportedLocales.map((locale) {
            return RadioListTile<Locale>(
              title: Text(L10n.getLanguageName(locale.languageCode)),
              value: locale,
              groupValue: currentLocale,
              onChanged: (v) {
                if (v != null) onChanged(v);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
