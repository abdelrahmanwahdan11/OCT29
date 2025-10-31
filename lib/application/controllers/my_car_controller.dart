import 'package:flutter/material.dart';

import '../../domain/entities/offer_watch.dart';

class MyCarController extends ChangeNotifier {
  MyCarController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String brand = '';
  String model = '';
  int year = DateTime.now().year;
  String condition = 'New';
  double price = 0;
  int mileage = 0;
  String fuel = 'Petrol';
  String transmission = 'Automatic';
  int seats = 5;
  int horsepower = 0;
  List<String> images = <String>[];
  List<String> spinset = <String>[];
  String description = '';
  String city = '';
  bool acceptingOffers = true;

  final List<OfferWatch> offerWatches = <OfferWatch>[];

  void addOfferWatch(OfferWatch watch) {
    offerWatches.add(watch);
    notifyListeners();
  }

  void removeOfferWatch(OfferWatch watch) {
    offerWatches.remove(watch);
    notifyListeners();
  }

  void saveForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
    }
  }
}
