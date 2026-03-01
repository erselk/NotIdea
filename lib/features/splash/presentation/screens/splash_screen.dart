import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/update/presentation/providers/app_update_provider.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/shared/widgets/notidea_logo_text.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _checkUpdateAndNavigate();
  }

  Future<void> _checkUpdateAndNavigate() async {
    // Logo animasyonunun görünmesi için küçük bir gecikme
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    try {
      final updateInfo = await ref.read(checkAppUpdateProvider.future);
      if (!mounted) return;

      if (updateInfo != null) {
        await _showUpdateDialog(l10n, updateInfo);
      }
    } catch (_) {
      // Güncelleme kontrolü başarısız olursa sessizce devam et
    }

    if (!mounted) return;

    final currentUser = await ref.read(currentUserProvider.future);
    if (!mounted) return;

    if (currentUser != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  Future<void> _showUpdateDialog(
    AppLocalizations l10n,
    AppUpdateInfo info,
  ) async {
    final latest = info.latest;

    // Locale'e göre changelog seçimi
    final localeName = l10n.localeName.toLowerCase();
    String? changelog;
    if (localeName.startsWith('tr')) {
      changelog = latest.changelogTr?.trim().isNotEmpty == true
          ? latest.changelogTr
          : latest.changelogEn;
    } else {
      changelog = latest.changelogEn?.trim().isNotEmpty == true
          ? latest.changelogEn
          : latest.changelogTr;
    }

    final hasChangelog = changelog != null && changelog.trim().isNotEmpty;

    final isForced = info.isForced;

    await showDialog<void>(
      context: context,
      barrierDismissible: !isForced,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            isForced
                ? l10n.updateRequiredTitle
                : l10n.updateAvailableTitle,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isForced
                    ? l10n.updateRequiredMessage
                    : l10n.updateAvailableMessage,
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.version}: ${info.currentVersion} → ${latest.version}',
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              if (hasChangelog) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.updateChangelog,
                  style: Theme.of(ctx).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      changelog!,
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            if (!isForced)
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.updateLater),
              ),
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(latest.downloadUrl);
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
                if (Navigator.of(ctx).canPop()) {
                  Navigator.of(ctx).pop();
                }
              },
              child: Text(l10n.updateNow),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const logoAsset = 'assets/images/logo.svg';

    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  logoAsset,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 24),
                const NotIdeaLogoText(width: 180),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
