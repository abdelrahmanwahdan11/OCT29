import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/car.dart';
import '../../domain/entities/tips.dart';

class LocalCarDataSource {
  const LocalCarDataSource();

  Future<List<Car>> loadCars() async {
    final raw = await rootBundle.loadString('assets/data/cars.json');
    final list = (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    return list.map(Car.fromJson).toList();
  }
}

class LocalTipDataSource {
  const LocalTipDataSource();

  Future<List<Tip>> fetchTips() async {
    final raw = await rootBundle.loadString('assets/data/tips.json');
    final list = (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    return list.map(Tip.fromJson).toList();
  }
}
