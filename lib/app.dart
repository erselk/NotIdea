import 'package:flutter/material.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:notidea/core/l10n/l10n.dart';
import 'package:notidea/core/router/app_router.dart';
import 'package:notidea/core/theme/app_theme.dart';
import 'package:notidea/shared/providers/locale_provider.dart';
import 'package:notidea/shared/providers/theme_provider.dart';

class NotIdeaApp extends ConsumerWidget {
  const NotIdeaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'NotIdea',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        FlutterQuillLocalizations.delegate,
      ],
      localeResolutionCallback: L10n.localeResolutionCallback,
      routerConfig: router,
    );
  }
}
