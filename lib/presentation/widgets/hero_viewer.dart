import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/car.dart';

class HeroViewer extends StatefulWidget {
  const HeroViewer({super.key, required this.car});

  final Car car;

  @override
  State<HeroViewer> createState() => _HeroViewerState();
}

class _HeroViewerState extends State<HeroViewer> with SingleTickerProviderStateMixin {
  late final PageController _controller;
  late final TransformationController _transformController;
  late final AnimationController _zoomController;
  Animation<Matrix4>? _zoomAnimation;
  int _index = 0;
  Timer? _autoTimer;
  bool _autoRotate = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _transformController = TransformationController();
    _zoomController = AnimationController(vsync: this, duration: const Duration(milliseconds: 240));
  }

  @override
  void dispose() {
    _zoomAnimation?.removeListener(_handleZoomAnimation);
    _stopAutoRotate();
    _zoomController.dispose();
    _transformController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(Matrix4 destination) {
    _zoomAnimation?.removeListener(_handleZoomAnimation);
    _zoomAnimation = Matrix4Tween(begin: _transformController.value, end: destination).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeOutBack),
    )
      ..addListener(_handleZoomAnimation);
    _zoomController.forward(from: 0);
  }

  void _handleZoomAnimation() {
    _transformController.value = _zoomAnimation!.value;
  }

  void _handleDoubleTap(BoxConstraints constraints) {
    final currentScale = _transformController.value.getMaxScaleOnAxis();
    if (currentScale > 1.2) {
      _animateTo(Matrix4.identity());
    } else {
      final focusX = constraints.maxWidth / 2;
      final focusY = constraints.maxHeight / 2;
      final zoomed = Matrix4.identity()
        ..translate(-focusX * 0.2, -focusY * 0.2)
        ..scale(1.6);
      _animateTo(zoomed);
    }
  }

  void _toggleAutoRotate() {
    if (_autoRotate) {
      _stopAutoRotate();
      setState(() => _autoRotate = false);
    } else {
      if (mounted) {
        setState(() => _autoRotate = true);
      }
      _startAutoRotate();
    }
  }

  void _startAutoRotate() {
    _autoTimer?.cancel();
    final frames = widget.car.spinset360?.isNotEmpty == true ? widget.car.spinset360! : widget.car.images;
    if (frames.length <= 1) {
      return;
    }
    _autoTimer = Timer.periodic(const Duration(milliseconds: 1400), (_) {
      if (!mounted) return;
      final next = (_index + 1) % frames.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOut,
      );
    });
  }

  void _stopAutoRotate() {
    _autoTimer?.cancel();
    _autoTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final frames = widget.car.spinset360?.isNotEmpty == true ? widget.car.spinset360! : widget.car.images;
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final frameLabel = l10n
        .t('frame_position')
        .replaceAll('{index}', '${_index + 1}')
        .replaceAll('{total}', '${frames.length}');

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewerHeight = math.min(math.max(constraints.maxWidth * 0.55, 220.0), 420.0);
        final locale = Localizations.localeOf(context);
        final fuelLabel = locale.languageCode == 'ar' ? widget.car.fuel.labelAr : widget.car.fuel.labelEn;
        final transmissionLabel = locale.languageCode == 'ar' ? widget.car.transmission.labelAr : widget.car.transmission.labelEn;
        return Hero(
          tag: 'car-${widget.car.id}',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: colors.accent.withOpacity(0.14),
                  blurRadius: 32,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: viewerHeight,
                    child: LayoutBuilder(
                      builder: (context, viewerConstraints) {
                        return GestureDetector(
                          onDoubleTap: () => _handleDoubleTap(viewerConstraints),
                          child: Semantics(
                            label: l10n.t('hero_viewer'),
                            image: true,
                            child: InteractiveViewer(
                              transformationController: _transformController,
                              onInteractionEnd: (_) {
                                if (_transformController.value.getMaxScaleOnAxis() <= 1.1) {
                                  _animateTo(Matrix4.identity());
                                }
                              },
                              minScale: 1,
                              maxScale: 2.8,
                              child: PageView.builder(
                                controller: _controller,
                                physics: const BouncingScrollPhysics(),
                                itemCount: frames.length,
                                onPageChanged: (value) {
                                  setState(() => _index = value);
                                  _animateTo(Matrix4.identity());
                                },
                                itemBuilder: (context, index) {
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        frames[index],
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(color: colors.accent),
                                          );
                                        },
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 96,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                colors.surface.withOpacity(0),
                                                colors.surface.withOpacity(0.82),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (frames.length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: _autoRotate ? l10n.t('pause_spin') : l10n.t('auto_spin'),
                            onPressed: frames.length > 1 ? _toggleAutoRotate : null,
                            icon: Icon(_autoRotate ? Icons.pause_circle_filled : Icons.play_circle_fill),
                            color: colors.accent,
                          ),
                          Expanded(
                            child: Semantics(
                              label: l10n.t('frame_scrub'),
                              child: Slider(
                                value: _index.toDouble(),
                                min: 0,
                                max: (frames.length - 1).toDouble(),
                                divisions: frames.length - 1,
                                onChangeStart: (_) {
                                  if (_autoRotate) {
                                    _stopAutoRotate();
                                    setState(() => _autoRotate = false);
                                  }
                                },
                                onChanged: (value) {
                                  final target = value.round();
                                  if (target != _index) {
                                    setState(() => _index = target);
                                    _controller.animateToPage(
                                      target,
                                      duration: const Duration(milliseconds: 260),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (frames.length > 1)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          frameLabel,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.subtext),
                        ),
                      ),
                    ),
                  if (frames.length > 1) const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      math.min(frames.length, 6),
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: _index == index ? 24 : 10,
                        decoration: BoxDecoration(
                          color: _index == index ? colors.accent : colors.accent.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 240.ms),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.car.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colors.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${widget.car.year} • $fuelLabel • $transmissionLabel',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.subtext),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: colors.accent.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '${widget.car.currency} ${widget.car.price.toStringAsFixed(0)}',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: colors.accent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.car.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurface),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.t('hero_viewer_scroll_hint'),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.subtext),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
