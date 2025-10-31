import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[Locale('ar'), Locale('en')];

  static const _localizedStrings = <String, Map<String, String>>{
    'app_name': {'ar': 'أوتو إنك', 'en': 'AutoInk'},
    'onboarding_title_1': {'ar': 'اكتشف السيارات بأسلوب e-ink', 'en': 'Discover cars in e-ink style'},
    'onboarding_body_1': {'ar': 'واجهة أحادية اللون، نظيفة وخالدة.', 'en': 'Pure black & white, clean, timeless.'},
    'onboarding_title_2': {'ar': 'عارض 360°', 'en': '360° Viewer'},
    'onboarding_body_2': {'ar': 'لف المركبة وشاهدها من كل الزوايا.', 'en': 'Spin the car and view from all angles.'},
    'onboarding_title_3': {'ar': 'ابحث، قارن، اضف سيارتك', 'en': 'Search, Compare, Add your car'},
    'onboarding_body_3': {'ar': 'كل الأدوات بين يديك.', 'en': 'Everything you need in one place.'},
    'auth_login': {'ar': 'تسجيل الدخول', 'en': 'Log in'},
    'auth_signup': {'ar': 'إنشاء حساب', 'en': 'Sign up'},
    'auth_guest': {'ar': 'الدخول كضيف', 'en': 'Continue as guest'},
    'forgot_password': {'ar': 'نسيت كلمة المرور؟', 'en': 'Forgot password?'},
    'email': {'ar': 'البريد الإلكتروني', 'en': 'Email'},
    'password': {'ar': 'كلمة المرور', 'en': 'Password'},
    'show_password': {'ar': 'إظهار', 'en': 'Show'},
    'hide_password': {'ar': 'إخفاء', 'en': 'Hide'},
    'home': {'ar': 'الرئيسية', 'en': 'Home'},
    'catalog': {'ar': 'الكتالوج', 'en': 'Catalog'},
    'search': {'ar': 'بحث', 'en': 'Search'},
    'compare': {'ar': 'المقارنة', 'en': 'Compare'},
    'my_car': {'ar': 'سيارتي', 'en': 'My Car'},
    'add_car': {'ar': 'إضافة مركبة', 'en': 'Add Car'},
    'ai_info': {'ar': 'معلومات بالذكاء الاصطناعي', 'en': 'AI Insight'},
    'filters': {'ar': 'الفلاتر', 'en': 'Filters'},
    'sort': {'ar': 'ترتيب', 'en': 'Sort'},
    'pull_to_refresh': {'ar': 'اسحب للتحديث', 'en': 'Pull to refresh'},
    'load_more': {'ar': 'تحميل المزيد', 'en': 'Load more'},
    'no_results': {'ar': 'لا توجد نتائج', 'en': 'No results'},
    'settings': {'ar': 'الإعدادات', 'en': 'Settings'},
    'appearance': {'ar': 'المظهر', 'en': 'Appearance'},
    'primary_color': {'ar': 'اللون الأساسي', 'en': 'Primary color'},
    'language': {'ar': 'اللغة', 'en': 'Language'},
    'run_tutorial': {'ar': 'عرض الدليل', 'en': 'Run Tutorial'},
    'privacy': {'ar': 'الخصوصية', 'en': 'Privacy'},
    'notifications': {'ar': 'الإشعارات', 'en': 'Notifications'},
    'favorite': {'ar': 'المفضلة', 'en': 'Favorite'},
    'place_offer': {'ar': 'ضع عرض سعر', 'en': 'Place Offer'},
    'watch_without_price': {'ar': 'عرض بدون سعر', 'en': 'List without price'},
    'maintenance_tips': {'ar': 'نصائح الصيانة', 'en': 'Maintenance tips'},
    'oil_change': {'ar': 'تبديل الزيت', 'en': 'Oil change'},
    'tire_pressure': {'ar': 'نفخ العجلات', 'en': 'Tire pressure'},
    'submit': {'ar': 'تأكيد', 'en': 'Submit'},
    'cancel': {'ar': 'إلغاء', 'en': 'Cancel'},
    'tutorial_toggle_label': {'ar': 'تفعيل الدليل التفاعلي', 'en': 'Enable guided tutorial'},
  };

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String translate(String key) {
    return _localizedStrings[key]?[locale.languageCode] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.contains(Locale(locale.languageCode));

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
