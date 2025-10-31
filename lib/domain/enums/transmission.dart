enum Transmission { automatic, manual }

extension TransmissionX on Transmission {
  String get labelEn => this == Transmission.automatic ? 'Automatic' : 'Manual';
  String get labelAr => this == Transmission.automatic ? 'أوتوماتيكي' : 'يدوي';

  static Transmission fromString(String value) {
    switch (value.toLowerCase()) {
      case 'automatic':
        return Transmission.automatic;
      case 'manual':
        return Transmission.manual;
      default:
        return Transmission.automatic;
    }
  }

  String get storageValue => name[0].toUpperCase() + name.substring(1);
}
