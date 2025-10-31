import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ImageOverlay extends StatefulWidget {
  const ImageOverlay({super.key, required this.images});

  final List<String> images;

  @override
  State<ImageOverlay> createState() => _ImageOverlayState();
}

class _ImageOverlayState extends State<ImageOverlay> {
  int index = 0;
  bool flipped = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Container(
          key: ValueKey<int>(index),
          color: Colors.black.withOpacity(0.92),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => setState(() => flipped = !flipped),
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        if (details.primaryVelocity != null && details.primaryVelocity! < 0 && index < widget.images.length - 1) {
                          index++;
                        } else if (details.primaryVelocity != null && details.primaryVelocity! > 0 && index > 0) {
                          index--;
                        }
                      });
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        final rotate = Tween(begin: 0.0, end: 1.0).animate(animation);
                        return AnimatedBuilder(
                          animation: rotate,
                          child: child,
                          builder: (context, child) {
                            final angle = rotate.value * 3.1415;
                            return Transform(
                              transform: Matrix4.rotationY(angle),
                              alignment: Alignment.center,
                              child: child,
                            );
                          },
                        );
                      },
                      child: flipped
                          ? Container(
                              key: const ValueKey<String>('back'),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: theme.colorScheme.background, borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                'تفاصيل الصورة ${index + 1}\n- مواصفات مختصرة\n- ملاحظات الصيانة',
                                style: theme.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ClipRRect(
                              key: const ValueKey<String>('front'),
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(widget.images[index], fit: BoxFit.cover)
                                  .animate()
                                  .fade(duration: const Duration(milliseconds: 300)),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.images.length,
                      (i) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == index ? theme.colorScheme.primary : Colors.white30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
