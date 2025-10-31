import 'package:flutter/material.dart';

class Car {
  const Car({
    required this.id,
    required this.make,
    required this.model,
    required this.trim,
    required this.year,
    required this.price,
    required this.currency,
    required this.condition,
    required this.mileageKm,
    required this.transmission,
    required this.fuel,
    required this.bodyType,
    required this.drive,
    required this.color,
    required this.images,
    required this.images360,
    required this.location,
    required this.postedAt,
    required this.sellerType,
    required this.engineCc,
    required this.hp,
    required this.doors,
    required this.seats,
    required this.notes,
  });

  final String id;
  final String make;
  final String model;
  final String trim;
  final int year;
  final double price;
  final String currency;
  final String condition;
  final int mileageKm;
  final String transmission;
  final String fuel;
  final String bodyType;
  final String drive;
  final String color;
  final List<String> images;
  final List<String> images360;
  final String location;
  final DateTime postedAt;
  final String sellerType;
  final int engineCc;
  final int hp;
  final int doors;
  final int seats;
  final String notes;

  String get fullName => '$make $model $trim';

  bool matchesQuery(String query) {
    final q = query.toLowerCase();
    return <String>[
      make,
      model,
      trim,
      year.toString(),
      bodyType,
      fuel,
      transmission,
      drive,
      color,
      location,
      notes,
    ].any((value) => value.toLowerCase().contains(q));
  }

  Car copyWith({
    double? price,
    String? notes,
  }) {
    return Car(
      id: id,
      make: make,
      model: model,
      trim: trim,
      year: year,
      price: price ?? this.price,
      currency: currency,
      condition: condition,
      mileageKm: mileageKm,
      transmission: transmission,
      fuel: fuel,
      bodyType: bodyType,
      drive: drive,
      color: color,
      images: images,
      images360: images360,
      location: location,
      postedAt: postedAt,
      sellerType: sellerType,
      engineCc: engineCc,
      hp: hp,
      doors: doors,
      seats: seats,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'make': make,
      'model': model,
      'trim': trim,
      'year': year,
      'price': price,
      'currency': currency,
      'condition': condition,
      'mileage_km': mileageKm,
      'transmission': transmission,
      'fuel': fuel,
      'body_type': bodyType,
      'drive': drive,
      'color': color,
      'images': images,
      'images360': images360,
      'location': location,
      'posted_at': postedAt.toIso8601String(),
      'seller_type': sellerType,
      'specs': <String, dynamic>{
        'engine_cc': engineCc,
        'hp': hp,
        'doors': doors,
        'seats': seats,
      },
      'notes': notes,
    };
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    final specs = json['specs'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return Car(
      id: json['id'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      trim: json['trim'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'USD',
      condition: json['condition'] as String? ?? 'used',
      mileageKm: json['mileage_km'] as int? ?? 0,
      transmission: json['transmission'] as String? ?? 'auto',
      fuel: json['fuel'] as String? ?? 'gasoline',
      bodyType: json['body_type'] as String? ?? 'sedan',
      drive: json['drive'] as String? ?? 'fwd',
      color: json['color'] as String? ?? 'white',
      images: (json['images'] as List<dynamic>? ?? <dynamic>[]).cast<String>(),
      images360: (json['images360'] as List<dynamic>? ?? <dynamic>[]).cast<String>(),
      location: json['location'] as String? ?? '',
      postedAt: DateTime.tryParse(json['posted_at'] as String? ?? '') ?? DateTime.now(),
      sellerType: json['seller_type'] as String? ?? 'individual',
      engineCc: specs['engine_cc'] as int? ?? 0,
      hp: specs['hp'] as int? ?? 0,
      doors: specs['doors'] as int? ?? 4,
      seats: specs['seats'] as int? ?? 5,
      notes: json['notes'] as String? ?? '',
    );
  }

  factory Car.empty() {
    return Car(
      id: '',
      make: '',
      model: '',
      trim: '',
      year: 0,
      price: 0,
      currency: 'USD',
      condition: 'new',
      mileageKm: 0,
      transmission: 'auto',
      fuel: 'gasoline',
      bodyType: 'sedan',
      drive: 'fwd',
      color: 'white',
      images: const <String>[],
      images360: const <String>[],
      location: '',
      postedAt: DateTime.now(),
      sellerType: 'dealer',
      engineCc: 0,
      hp: 0,
      doors: 4,
      seats: 5,
      notes: '',
    );
  }
}

class CompareItem {
  const CompareItem({required this.carId, required this.selectedAt});

  final String carId;
  final DateTime selectedAt;
}

class Listing {
  const Listing({required this.carId, required this.showPrice, this.watchersOffers = const <Offer>[]});

  final String carId;
  final bool showPrice;
  final List<Offer> watchersOffers;
}

class Offer {
  const Offer({required this.amount, required this.currency, required this.dateTime});

  final double amount;
  final String currency;
  final DateTime dateTime;
}

class TipsPreference {
  const TipsPreference({required this.carId, required this.targetPrice});

  final String carId;
  final double targetPrice;
}
