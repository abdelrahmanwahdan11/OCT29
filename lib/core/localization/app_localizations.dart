import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const Map<String, Map<String, String>> _localizedValues = <String, Map<String, String>>{
    'en': {
      'brands': 'Brands',
      'all': 'All',
      'new': 'New',
      'used': 'Used',
      'search': 'Search',
      'compare': 'Compare',
      'add_to_compare': 'Add to Compare',
      'favorites': 'Favorites',
      'catalog': 'Catalog',
      'my_car': 'My Car',
      'settings': 'Settings',
      'ai_explain': 'AI Explain',
      'continue': 'Continue',
      'skip': 'Skip',
      'next': 'Next',
      'get_started': 'Get Started',
      'guest': 'Continue as guest',
    },
    'ar': {
      'brands': 'الماركات',
      'all': 'الكل',
      'new': 'جديدة',
      'used': 'مستعملة',
      'search': 'بحث',
      'compare': 'مقارنة',
      'add_to_compare': 'أضف للمقارنة',
      'favorites': 'المفضلة',
      'catalog': 'الكتالوج',
      'my_car': 'سيارتي',
      'settings': 'الإعدادات',
      'ai_explain': 'تحليل بالذكاء الاصطناعي',
      'continue': 'متابعة',
      'skip': 'تخطي',
      'next': 'التالي',
      'get_started': 'ابدأ الآن',
      'guest': 'الدخول كضيف',
    },
  };

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String t(String key) {
    final values = _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    return values[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => <String>['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
