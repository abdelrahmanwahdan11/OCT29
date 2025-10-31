enum FuelType { petrol, diesel, hybrid, electric }

extension FuelTypeX on FuelType {
  String get labelEn {
    switch (this) {
      case FuelType.petrol:
        return 'Petrol';
      case FuelType.diesel:
        return 'Diesel';
      case FuelType.hybrid:
        return 'Hybrid';
      case FuelType.electric:
        return 'Electric';
    }
  }

  String get labelAr {
    switch (this) {
      case FuelType.petrol:
        return 'بنزين';
      case FuelType.diesel:
        return 'ديزل';
      case FuelType.hybrid:
        return 'هجين';
      case FuelType.electric:
        return 'كهرباء';
    }
  }

  static FuelType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'petrol':
        return FuelType.petrol;
      case 'diesel':
        return FuelType.diesel;
      case 'hybrid':
        return FuelType.hybrid;
      case 'electric':
        return FuelType.electric;
      default:
        return FuelType.petrol;
    }
  }

  String get storageValue => name[0].toUpperCase() + name.substring(1);
}
