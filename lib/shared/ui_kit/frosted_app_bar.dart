import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class FrostedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FrostedAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<NeoTokens>() ??
        const NeoTokens(
          cardRadius: 22,
          navRadius: 24,
          appBarRadius: 20,
          inputRadius: 18,
          chipRadius: 18,
          backgroundImageOpacity: 0.03,
          backgroundOverlayLight: Color(0x0AFFFFFF),
          backgroundOverlayDark: Color(0x24000000),
        );
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Material(
          color: scheme.surface,
          elevation: 6,
          shadowColor: scheme.shadow.withOpacity(0.18),
          borderRadius: BorderRadius.circular(tokens.appBarRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                leading ?? const SizedBox(width: 24),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                      child: title ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
                if (actions != null)
                  Row(children: actions!)
                else
                  const SizedBox(width: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
