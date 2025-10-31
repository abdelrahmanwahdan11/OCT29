import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../domain/entities/offer_watch.dart';
import '../../domain/enums/condition.dart';
import '../../domain/enums/fuel_type.dart';
import '../controllers/cars_controller.dart';
import '../controllers/my_car_controller.dart';
import '../controllers/saved_search_controller.dart';

enum ReviewStatus { pass, warning, fail }

class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.status,
    this.metricKey,
    this.metricValues = const <String, String>{},
    this.actionKey,
    this.autoResolvable = false,
    this.manualOverride = false,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final ReviewStatus status;
  final String? metricKey;
  final Map<String, String> metricValues;
  final String? actionKey;
  final bool autoResolvable;
  final bool manualOverride;
}

class ReviewController extends ChangeNotifier {
  ReviewController({
    required this.carsController,
    required this.savedSearchController,
    required this.myCarController,
  });

  final CarsController carsController;
  final SavedSearchController savedSearchController;
  final MyCarController myCarController;

  bool _analyzing = false;
  List<ReviewItem> _items = <ReviewItem>[];
  final Set<String> _manualApprovals = <String>{};

  bool get isAnalyzing => _analyzing;
  List<ReviewItem> get observations => List.unmodifiable(_items);

  Future<void> runAnalysis() async {
    if (_analyzing) return;
    _analyzing = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 120));

    final List<ReviewItem> items = <ReviewItem>[];
    final int totalCars = carsController.allCars.length;
    final ReviewStatus catalogStatus = totalCars == 0
        ? ReviewStatus.fail
        : (totalCars < 25 ? ReviewStatus.warning : ReviewStatus.pass);
    items.add(_buildItem(
      id: 'catalog',
      status: catalogStatus,
      titleKey: 'review_issue_catalog',
      descriptionKey: 'review_issue_catalog_desc',
      metricKey: 'review_metric_cars',
      metricValues: <String, String>{'count': '$totalCars'},
      actionKey: 'review_action_refresh_catalog',
      autoResolvable: true,
    ));

    final int withSpinset = totalCars == 0
        ? 0
        : carsController.allCars
            .where((car) => (car.spinset360?.length ?? 0) >= 12)
            .length;
    final double coverage = totalCars == 0 ? 0 : withSpinset / totalCars;
    final ReviewStatus spinStatus = coverage >= 0.7
        ? ReviewStatus.pass
        : (coverage >= 0.45 ? ReviewStatus.warning : ReviewStatus.fail);
    items.add(_buildItem(
      id: 'spinset',
      status: spinStatus,
      titleKey: 'review_issue_spinset',
      descriptionKey: 'review_issue_spinset_desc',
      metricKey: 'review_metric_spinset',
      metricValues: <String, String>{
        'percent': coverage == 0 ? '0' : coverage.multiplyPercentage(),
      },
      actionKey: 'review_action_normalize_spinsets',
      autoResolvable: true,
    ));

    final Map<String, List<String>> missing = AppLocalizations.missingLocalizationKeys();
    final int missingCount = missing.values.fold<int>(0, (sum, list) => sum + list.length);
    final ReviewStatus localizationStatus =
        missingCount == 0 ? ReviewStatus.pass : ReviewStatus.fail;
    items.add(_buildItem(
      id: 'localization',
      status: localizationStatus,
      titleKey: 'review_issue_localization',
      descriptionKey: 'review_issue_localization_desc',
      metricKey: 'review_metric_missing_keys',
      metricValues: <String, String>{'count': '$missingCount'},
      autoResolvable: false,
    ));

    final int savedSearchCount = savedSearchController.searches.length;
    final ReviewStatus savedSearchStatus =
        savedSearchCount > 0 ? ReviewStatus.pass : ReviewStatus.warning;
    items.add(_buildItem(
      id: 'saved_search',
      status: savedSearchStatus,
      titleKey: 'review_issue_saved_search',
      descriptionKey: 'review_issue_saved_search_desc',
      metricKey: 'review_metric_saved_search',
      metricValues: <String, String>{'count': '$savedSearchCount'},
      actionKey: 'review_action_seed_saved_search',
      autoResolvable: true,
    ));

    final int watchCount = myCarController.offerWatches.length;
    final ReviewStatus watchStatus =
        watchCount > 0 ? ReviewStatus.pass : ReviewStatus.warning;
    items.add(_buildItem(
      id: 'offer_watch',
      status: watchStatus,
      titleKey: 'review_issue_offer_watch',
      descriptionKey: 'review_issue_offer_watch_desc',
      metricKey: 'review_metric_offer_watch',
      metricValues: <String, String>{'count': '$watchCount'},
      actionKey: 'review_action_seed_offer_watch',
      autoResolvable: true,
    ));

    _items = items;
    _analyzing = false;
    notifyListeners();
  }

  Future<void> applyFix(String id) async {
    switch (id) {
      case 'catalog':
        await carsController.reseedFromAssets();
        _manualApprovals.remove(id);
        break;
      case 'spinset':
        await carsController.normalizeSpinsets();
        _manualApprovals.remove(id);
        break;
      case 'saved_search':
        if (savedSearchController.searches.isEmpty) {
          await savedSearchController.addSearch(
            'Electric spotlight',
            CarsFilter(
              brands: <String>{'Tesla'},
              condition: Condition.newCar,
              minYear: DateTime.now().year - 3,
              fuels: <FuelType>{FuelType.electric},
            ),
          );
        }
        _manualApprovals.remove(id);
        break;
      case 'offer_watch':
        if (myCarController.offerWatches.isEmpty && carsController.allCars.isNotEmpty) {
          final sample = carsController.allCars.first;
          await myCarController.addOfferWatch(
            OfferWatch(
              carId: sample.id,
              targetPrice: (sample.price * 0.95).roundToDouble(),
              notifyOnMatch: true,
            ),
          );
        }
        _manualApprovals.remove(id);
        break;
      default:
        return;
    }
    await runAnalysis();
  }

  Future<void> markApproved(String id) async {
    _manualApprovals.add(id);
    await runAnalysis();
  }

  ReviewItem _buildItem({
    required String id,
    required ReviewStatus status,
    required String titleKey,
    required String descriptionKey,
    String? metricKey,
    Map<String, String> metricValues = const <String, String>{},
    String? actionKey,
    required bool autoResolvable,
  }) {
    bool manual = _manualApprovals.contains(id);
    if (manual && status == ReviewStatus.pass) {
      _manualApprovals.remove(id);
      manual = false;
    }
    final ReviewStatus effectiveStatus = manual ? ReviewStatus.pass : status;
    return ReviewItem(
      id: id,
      titleKey: titleKey,
      descriptionKey: descriptionKey,
      status: effectiveStatus,
      metricKey: metricKey,
      metricValues: metricValues,
      actionKey: actionKey,
      autoResolvable: autoResolvable,
      manualOverride: manual && status != ReviewStatus.pass,
    );
  }
}

extension _PercentageFormat on double {
  String multiplyPercentage() => (this * 100).toStringAsFixed(0);
}
