enum Condition { newCar, used }

extension ConditionX on Condition {
  String get labelEn => this == Condition.newCar ? 'New' : 'Used';
  String get labelAr => this == Condition.newCar ? 'جديدة' : 'مستعملة';

  static Condition fromString(String value) {
    switch (value.toLowerCase()) {
      case 'new':
        return Condition.newCar;
      case 'used':
        return Condition.used;
      default:
        return Condition.used;
    }
  }

  String get storageValue => this == Condition.newCar ? 'New' : 'Used';
}
