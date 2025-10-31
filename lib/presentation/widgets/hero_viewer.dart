import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

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
  bool _modelAutoRotate = true;
  bool _modelLoaded = false;
  String _cameraOrbit = '0deg 75deg auto';

  bool get _useModelViewer => widget.car.model3dUrl?.isNotEmpty == true;

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
    if (_useModelViewer) {
      return;
    }
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

  void _toggleModelAutoRotate() {
    setState(() => _modelAutoRotate = !_modelAutoRotate);
  }

  void _resetModelView() {
    setState(() {
      _cameraOrbit = '0deg 75deg auto';
      _modelAutoRotate = true;
    });
  }

  void _onModelLoaded() {
    if (!_modelLoaded && mounted) {
      setState(() => _modelLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final frames = widget.car.spinset360?.isNotEmpty == true ? widget.car.spinset360! : widget.car.images;
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final bool hasFrames = frames.length > 1;
    final String frameLabel = l10n
        .t('frame_position')
        .replaceAll('{index}', '${_index + 1}')
        .replaceAll('{total}', '${frames.length}');

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewerHeight = math.min(math.max(constraints.maxWidth * 0.55, 220.0), 420.0);
        final locale = Localizations.localeOf(context);
        final fuelLabel = locale.languageCode == 'ar' ? widget.car.fuel.labelAr : widget.car.fuel.labelEn;
        final transmissionLabel = locale.languageCode == 'ar' ? widget.car.transmission.labelAr : widget.car.transmission.labelEn;
        final List<Widget> sections = <Widget>[
          SizedBox(
            height: viewerHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: _useModelViewer ? _buildModelViewerWidget(colors, l10n) : _buildSpinViewer(frames, colors, l10n),
            ),
          ),
        ];

        if (_useModelViewer) {
          sections
            ..add(const SizedBox(height: 12))
            ..add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: _toggleModelAutoRotate,
                      icon: Icon(_modelAutoRotate ? Icons.pause_circle_filled : Icons.play_circle_fill),
                      label: Text(_modelAutoRotate ? l10n.t('pause_spin') : l10n.t('auto_spin')),
                    ),
                    OutlinedButton.icon(
                      onPressed: _resetModelView,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.t('reset_view')),
                    ),
                  ],
                ),
              ),
            )
            ..add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.t('model_controls_hint'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.subtext),
                ),
              ),
            );
        } else {
          sections.add(const SizedBox(height: 12));
          if (hasFrames) {
            sections.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: _autoRotate ? l10n.t('pause_spin') : l10n.t('auto_spin'),
                      onPressed: hasFrames ? _toggleAutoRotate : null,
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
            );
            sections.add(
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
            );
            sections.add(const SizedBox(height: 8));
            sections.add(
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
            );
          }
        }

        sections
          ..add(const SizedBox(height: 16))
          ..add(_buildInfoPanel(l10n, colors, fuelLabel, transmissionLabel, conditionLabel));

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
                children: sections,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpinViewer(List<String> frames, AppColors colors, AppLocalizations l10n) {
    return LayoutBuilder(
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
                          return Center(child: CircularProgressIndicator(color: colors.accent));
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
    );
  }

  Widget _buildModelViewerWidget(AppColors colors, AppLocalizations l10n) {
    return Semantics(
      label: l10n.t('view_in_3d'),
      image: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ModelViewer(
            key: ValueKey(widget.car.model3dUrl),
            src: widget.car.model3dUrl!,
            autoRotate: _modelAutoRotate,
            cameraOrbit: _cameraOrbit,
            cameraControls: true,
            backgroundColor: colors.card,
            ar: false,
            disableZoom: false,
            interactionPrompt: InteractionPrompt.auto,
            onModelLoaded: (_) => _onModelLoaded(),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.accent.withOpacity(0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l10n.t('view_in_3d'),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.surface.withOpacity(0),
                      colors.surface.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!_modelLoaded)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface.withOpacity(0.86),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: colors.accent),
                    const SizedBox(height: 12),
                    Text(
                      l10n.t('model_loading'),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.onSurface),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel(
    AppLocalizations l10n,
    AppColors colors,
    String fuelLabel,
    String transmissionLabel,
    String conditionLabel,
  ) {
    final price = '${widget.car.currency} ${widget.car.price.toStringAsFixed(0)}';
    final acceleration = l10n
        .t('acceleration_time')
        .replaceAll('{seconds}', widget.car.acceleration0100.toStringAsFixed(1));
    final location = widget.car.locationCity;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 280),
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
                '${widget.car.year} • $fuelLabel • $transmissionLabel • $conditionLabel',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.subtext),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      price,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _InfoStat(
                    icon: IconlyBold.time_circle,
                    label: l10n.t('acceleration'),
                    value: acceleration,
                  ),
                  _InfoStat(
                    icon: IconlyBold.setting,
                    label: l10n.t('drivetrain'),
                    value: widget.car.drivetrain,
                  ),
                  _InfoStat(
                    icon: IconlyBold.location,
                    label: l10n.t('city'),
                    value: location,
                  ),
                  if (widget.car.batteryRangeKm != null)
                    _InfoStat(
                      icon: IconlyBold.discovery,
                      label: l10n.t('battery_range'),
                      value: '${widget.car.batteryRangeKm} km',
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.car.description,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.onSurface),
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
    );
  }
}

class _InfoStat extends StatelessWidget {
  const _InfoStat({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      constraints: const BoxConstraints(minWidth: 140, maxWidth: 220),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardAlt,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.accent, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(color: colors.subtext),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
