import 'package:flutter/material.dart';

import 'blur_container.dart';

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
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: BlurContainer(
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              leading ?? const SizedBox(width: 24),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
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
    );
  }
}
