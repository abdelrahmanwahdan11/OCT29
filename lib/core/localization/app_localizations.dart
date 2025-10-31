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
      'filter': 'Filter',
      'apply': 'Apply',
      'clear': 'Clear',
      'saved_searches': 'Saved Searches',
      'save_search': 'Save Search',
      'recent_views': 'Recently viewed',
      'flip_for_specs': 'Tap again to flip for specs',
      'view_details': 'View details',
      'show_specs': 'Show specs',
      'show_overview': 'Show overview',
      'no_cars_found': 'No cars found',
      'adjust_filters': 'Adjust filters',
      'search_saved': 'Search saved',
      'compare_full': 'Compare list is full',
      'condition': 'Condition',
      'favorites_empty': 'No favorites yet',
      'compare_empty': 'Add cars to compare.',
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
      'filter': 'فلترة',
      'apply': 'تطبيق',
      'clear': 'مسح',
      'saved_searches': 'عمليات بحث محفوظة',
      'save_search': 'حفظ البحث',
      'recent_views': 'شوفتها مؤخرًا',
      'flip_for_specs': 'اضغط مرة أخرى لقلب البطاقة للمواصفات',
      'view_details': 'عرض التفاصيل',
      'show_specs': 'عرض المواصفات',
      'show_overview': 'عرض الملخص',
      'no_cars_found': 'لا توجد سيارات',
      'adjust_filters': 'تعديل الفلاتر',
      'search_saved': 'تم حفظ البحث',
      'compare_full': 'قائمة المقارنة ممتلئة',
      'condition': 'الحالة',
      'favorites_empty': 'لا مفضلة بعد',
      'compare_empty': 'أضف سيارات للمقارنة.',
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
