import 'dart:async';

import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('ar'), Locale('en')];

  static const _localizedValues = {
    'ar': {
      'app_name': 'كتالوج',
      'get_started': 'ابدأ',
      'next': 'التالي',
      'skip': 'تخطي',
      'previous': 'السابق',
      'finish': 'إنهاء',
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'guest_login': 'الدخول كضيف',
      'email': 'البريد الإلكتروني',
      'phone': 'رقم الهاتف',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'name': 'الاسم',
      'home': 'الرئيسية',
      'explore': 'استكشاف',
      'favorites': 'المفضلة',
      'profile': 'حسابي',
      'search_hint': 'ابحث عن عناصر...',
      'categories': 'التصنيفات',
      'price': 'السعر',
      'rating': 'التقييم',
      'add_to_cart': 'أضف للسلة',
      'save': 'حفظ',
      'remove': 'إزالة',
      'details': 'التفاصيل',
      'language': 'اللغة',
      'theme': 'الوضع',
      'dark_mode': 'الوضع الليلي',
      'light_mode': 'الوضع الفاتح',
      'notifications': 'الإشعارات',
      'about': 'حول التطبيق',
      'policy': 'سياسة الخصوصية',
      'pull_to_refresh': 'اسحب للتحديث',
      'loading': 'جاري التحميل...',
      'empty_state': 'لا توجد نتائج',
      'network_error': 'خطأ في الاتصال',
      'try_again': 'إعادة المحاولة',
      'validation_required': 'هذا الحقل مطلوب',
      'validation_email': 'رجاء أدخل بريدًا صالحًا',
      'validation_password': 'كلمة المرور 8 أحرف على الأقل',
      'validation_password_match': 'كلمتا المرور غير متطابقتين',
      'validation_phone': 'رقم الهاتف غير صالح',
      'logout': 'تسجيل الخروج',
      'guest': 'ضيف',
      'system': 'النظام',
      'light': 'فاتح',
      'dark': 'داكن',
      'welcome_headline': 'اكتشف أفضل المنتجات',
      'welcome_body': 'تصفح تشكيلتنا المتنوعة واحفظ ما يعجبك بسهولة.',
      'secure_headline': 'تجربة دخول سلسة',
      'secure_body': 'سجل أو ادخل كضيف مع حفظ تفضيلاتك.',
      'explore_headline': 'ابحث واستكشف',
      'explore_body': 'مرشحات، بحث متطور، وتصفح لا نهائي.',
      'guest_message': 'أنت في وضع الضيف. سجل للحصول على كل المزايا.'
    },
    'en': {
      'app_name': 'Catalog',
      'get_started': 'Get Started',
      'next': 'Next',
      'skip': 'Skip',
      'previous': 'Previous',
      'finish': 'Finish',
      'login': 'Login',
      'register': 'Create Account',
      'guest_login': 'Continue as Guest',
      'email': 'Email',
      'phone': 'Phone',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'name': 'Name',
      'home': 'Home',
      'explore': 'Explore',
      'favorites': 'Favorites',
      'profile': 'Profile',
      'search_hint': 'Search items...',
      'categories': 'Categories',
      'price': 'Price',
      'rating': 'Rating',
      'add_to_cart': 'Add to Cart',
      'save': 'Save',
      'remove': 'Remove',
      'details': 'Details',
      'language': 'Language',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'notifications': 'Notifications',
      'about': 'About',
      'policy': 'Privacy Policy',
      'pull_to_refresh': 'Pull to refresh',
      'loading': 'Loading...',
      'empty_state': 'No results',
      'network_error': 'Network error',
      'try_again': 'Try again',
      'validation_required': 'This field is required',
      'validation_email': 'Please enter a valid email',
      'validation_password': 'Password must be at least 8 characters',
      'validation_password_match': 'Passwords do not match',
      'validation_phone': 'Invalid phone number',
      'logout': 'Logout',
      'guest': 'Guest',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'welcome_headline': 'Discover top products',
      'welcome_body': 'Browse a curated mix and save your favorites easily.',
      'secure_headline': 'Smooth sign-in experience',
      'secure_body': 'Register or continue as guest with preferences saved.',
      'explore_headline': 'Search and explore',
      'explore_body': 'Filters, smart search, and endless browsing.',
      'guest_message': 'You are browsing as guest. Sign in for full benefits.'
    }
  };

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String translate(String key) {
    final values = _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    return values[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
