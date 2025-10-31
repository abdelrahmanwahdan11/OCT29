import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../application/controllers/app_controllers.dart';
import '../../core/localization/app_localizations.dart';
import '../../domain/entities/car.dart';
import '../components/car_card.dart';
import '../components/compare_bar.dart';
import '../components/eink_scaffold.dart';
import '../components/skeleton_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _filtersKey = GlobalKey();
  final GlobalKey _compareKey = GlobalKey();
  final GlobalKey _addCarKey = GlobalKey();
  TutorialCoachMark? _coachMark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowTutorial());
  }

  void _maybeShowTutorial() {
    if (!widget.controllers.coachMarkController.enabled) return;
    final localization = AppLocalizations.of(context);
    _coachMark = TutorialCoachMark(
      targets: <TargetFocus>[
        TargetFocus(
          identify: 'hero360',
          keyTarget: _heroKey,
          contents: <TargetContent>[
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(localization.translate('onboarding_title_2'), style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
        TargetFocus(
          identify: 'filters',
          keyTarget: _filtersKey,
          contents: <TargetContent>[
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(localization.translate('filters'), style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
        TargetFocus(
          identify: 'compare',
          keyTarget: _compareKey,
          contents: <TargetContent>[
            TargetContent(
              align: ContentAlign.top,
              child: Text(localization.translate('compare'), style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
        TargetFocus(
          identify: 'addCar',
          keyTarget: _addCarKey,
          contents: <TargetContent>[
            TargetContent(
              align: ContentAlign.top,
              child: Text(localization.translate('add_car'), style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
      ],
      skipWidget: const Text('تخطي'),
    )
      ..show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Stack(
      children: <Widget>[
        EInkScaffold(
          appBar: AppBar(
            title: Text(localization.translate('home')),
            actions: <Widget>[
              IconButton(icon: const Icon(IconlyLight.search), onPressed: () => Navigator.of(context).pushNamed('/search')),
              IconButton(icon: const Icon(IconlyLight.setting), onPressed: () => Navigator.of(context).pushNamed('/settings')),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => widget.controllers.homeController.load(),
            child: ListView(
              children: <Widget>[
                KeyedSubtree(key: _heroKey, child: _Hero360Section(controllers: widget.controllers)),
                const SizedBox(height: 16),
                KeyedSubtree(
                  key: _filtersKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(localization.translate('filters'), style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <String>['جديد', 'مستعمل', 'سيدان', 'SUV']
                            .map((label) => Chip(label: Text(label)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _HorizontalList(controllers: widget.controllers, title: 'موصى به', stream: widget.controllers.homeController.recommended),
                const SizedBox(height: 24),
                Text(localization.translate('load_more'), style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                StreamBuilder<List<Car>>(
                  stream: widget.controllers.homeController.latest,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(children: List.generate(3, (_) => const SkeletonListTile()));
                    }
                    final cars = snapshot.data!;
                    return Column(
                      children: cars
                          .map((car) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CarCard(car: car, controllers: widget.controllers),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            key: _addCarKey,
            onPressed: () => Navigator.of(context).pushNamed('/add-car'),
            child: const Icon(IconlyBold.plus),
          ),
        ),
        CompareBar(controllers: widget.controllers, overlayKey: _compareKey),
      ],
    );
  }
}

class _Hero360Section extends StatefulWidget {
  const _Hero360Section({required this.controllers});

  final AppControllerRegistry controllers;

  @override
  State<_Hero360Section> createState() => _Hero360SectionState();
}

class _Hero360SectionState extends State<_Hero360Section> {
  double _drag = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.controllers.homeController.heroFrame,
      builder: (context, value, _) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            _drag += details.delta.dx;
            if (_drag.abs() > 12) {
              final next = value + (_drag.isNegative ? 1 : -1);
              final normalized = (next % 36 + 36) % 36;
              widget.controllers.homeController.updateHeroFrame(normalized);
              _drag = 0;
            }
          },
          onDoubleTap: () => widget.controllers.homeController.updateHeroFrame(0),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).cardColor,
            ),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.network(
                    'https://picsum.photos/seed/frame$value/800/400',
                    fit: BoxFit.cover,
                  ).animate().fade(duration: const Duration(milliseconds: 300)),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(IconlyBold.info_square),
                    label: Text(AppLocalizations.of(context).translate('ai_info')),
                  ),
                ),
              ],
            ),
          ).animate().fade(duration: const Duration(milliseconds: 350)).slideY(begin: 0.2, end: 0, duration: const Duration(milliseconds: 350)),
        );
      },
    );
  }
}

class _HorizontalList extends StatelessWidget {
  const _HorizontalList({required this.controllers, required this.title, required this.stream});

  final AppControllerRegistry controllers;
  final String title;
  final Stream<List<Car>> stream;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: StreamBuilder<List<Car>>(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, __) => const SizedBox(width: 240, child: SkeletonListTile()),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: 3,
                );
              }
              final cars = snapshot.data!;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cars.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => SizedBox(
                  width: 260,
                  child: CarCard(car: cars[index], controllers: controllers),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
