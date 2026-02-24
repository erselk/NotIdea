import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:notidea/l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/shared/widgets/app_error_widget.dart';
import 'package:notidea/shared/widgets/loading_widget.dart';

enum LegalDocumentType { privacyPolicy, termsOfService }

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key, required this.documentType});

  final LegalDocumentType documentType;

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  late Future<String> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _loadDocument();
  }

  Future<String> _loadDocument() async {
    final assetPath = switch (widget.documentType) {
      LegalDocumentType.privacyPolicy => 'assets/legal/privacy_policy.md',
      LegalDocumentType.termsOfService => 'assets/legal/terms_of_service.md',
    };
    final raw = await rootBundle.loadString(assetPath);
    return raw
        .replaceAll('[APP_NAME]', 'NotIdea')
        .replaceAll('[CONTACT_EMAIL]', 'support@notidea.ersel.dev')
        .replaceAll('[EFFECTIVE_DATE]', '2026-01-01');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = switch (widget.documentType) {
      LegalDocumentType.privacyPolicy => l10n.privacyPolicy,
      LegalDocumentType.termsOfService => l10n.termsOfService,
    };

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<String>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: l10n.errorGeneral,
              onRetry: () => setState(() => _contentFuture = _loadDocument()),
            );
          }

          final content = snapshot.data ?? '';
          return _MarkdownBody(content: content);
        },
      ),
    );
  }
}

class _MarkdownBody extends StatelessWidget {
  const _MarkdownBody({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return Markdown(
      data: content,
      selectable: true,
      padding: const EdgeInsets.all(20),
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
        }
      },
      styleSheet: MarkdownStyleSheet(
        h1: theme.textTheme.displaySmall,
        h2: theme.textTheme.headlineMedium?.copyWith(height: 2.0),
        h3: theme.textTheme.headlineSmall?.copyWith(height: 1.8),
        p: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
        listBullet: theme.textTheme.bodyMedium,
        strong: const TextStyle(fontWeight: FontWeight.w700),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: appColors.primary, width: 3),
          ),
        ),
        blockquotePadding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: appColors.divider, width: 1),
          ),
        ),
        codeblockDecoration: BoxDecoration(
          color: appColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
