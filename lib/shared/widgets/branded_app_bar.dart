import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notidea/shared/widgets/app_scaffold.dart';

/// Tüm drawer sayfalarında kullanılan tutarlı marka AppBar'ı.
/// Logo ikon + iki renkli sayfa başlığı gösterir.
class BrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Koyu renkte gösterilecek ilk kısım (#374241)
  final String titleFirst;
  /// Yeşil renkte gösterilecek ikinci kısım (#06A74D)
  final String titleSecond;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;

  const BrandedAppBar({
    super.key,
    required this.titleFirst,
    required this.titleSecond,
    this.actions,
    this.bottom,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(76 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const titleStyle = TextStyle(
      fontFamily: 'UltimaPro',
      fontSize: 36,
      fontWeight: FontWeight.w900,
      letterSpacing: -2.5,
      height: 1.0,
    );

    return AppBar(
      toolbarHeight: 76,
      centerTitle: true,
      backgroundColor: backgroundColor ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 72,
      leading: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Center(
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              icon: const Icon(Icons.menu, size: 28),
              onPressed: () => AppScaffold.openDrawer(context),
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            theme.brightness == Brightness.dark
                ? 'assets/images/logodark-notext.svg'
                : 'assets/images/logolight-notext.svg',
            height: 36,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Transform.translate(
              offset: const Offset(0, 6),
              child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: titleFirst,
                    style: titleStyle.copyWith(
                      color: const Color(0xFF374241),
                    ),
                  ),
                  TextSpan(
                    text: titleSecond,
                    style: titleStyle.copyWith(
                      color: const Color(0xFF06A74D),
                    ),
                  ),
                ],
              ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        ...?actions,
        const SizedBox(width: 20),
      ],
      bottom: bottom,
    );
  }
}
