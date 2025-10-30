import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_name': 'Insta Design Clone',
      'skip': 'Skip',
      'next': 'Next',
      'start': 'Start',
      'onb1_t': 'Discover',
      'onb1_d': 'Swipe through a modern feed with smooth animations.',
      'onb2_t': 'Connect',
      'onb2_d': 'Sign in or continue as a guest — no backend needed.',
      'onb3_t': 'Customize',
      'onb3_d': 'Arabic/English & dark mode. Your preferences are saved.',
      'login': 'Login',
      'signup': 'Create Account',
      'guest': 'Continue as Guest',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      "dont_have_account": "Don't have an account? ",
      'have_account': 'Already have an account? ',
      'create_one': 'Create one',
      'sign_in': 'Sign in',
      'sign_up': 'Sign up',
      'home': 'Home',
      'search': 'Search',
      'profile': 'Profile',
      'settings': 'Settings',
      'design_tokens': 'Design & Theme Details',
      'theme': 'Theme',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'language': 'Language',
      'arabic': 'Arabic',
      'english': 'English',
      'logout': 'Log out',
      'welcome': 'Welcome',
      'invalid_email': 'Enter a valid email',
      'invalid_password': 'Password must be at least 8 chars and include a number',
      'passwords_not_match': 'Passwords do not match',
      'pull_to_refresh': 'Pull to refresh',
      'loading': 'Loading...',
      'no_more': 'No more items',
      'as_guest': 'Guest',
      'feed': 'Feed',
      'likes': 'likes',
      'comments': 'comments',
      'just_now': 'just now',
      'tap_settings': 'Tap the gear to change language/theme',
      'edit_profile': 'Edit profile',
      'open_design_system': 'Open design details',
      'stories': 'Stories',
    },
    'ar': {
      'app_name': 'نسخة التصميم',
      'skip': 'تخطي',
      'next': 'التالي',
      'start': 'ابدأ',
      'onb1_t': 'اكتشف',
      'onb1_d': 'تصفح خلاصة عصرية مع انتقالات سلسة.',
      'onb2_t': 'تواصل',
      'onb2_d': 'سجل دخولك أو ادخل كضيف — بدون أي باك-إند.',
      'onb3_t': 'خصص',
      'onb3_d': 'عربي/إنجليزي + الوضع الليلي. تحفظ التفضيلات تلقائيًا.',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'guest': 'الدخول كضيف',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'dont_have_account': 'لا تملك حسابًا؟ ',
      'have_account': 'لديك حساب؟ ',
      'create_one': 'أنشئ واحدًا',
      'sign_in': 'دخول',
      'sign_up': 'تسجيل',
      'home': 'الرئيسية',
      'search': 'بحث',
      'profile': 'الملف',
      'settings': 'الإعدادات',
      'design_tokens': 'تفاصيل التصميم والثيم',
      'theme': 'الثيم',
      'system': 'النظام',
      'light': 'فاتح',
      'dark': 'غامق',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'الإنجليزية',
      'logout': 'تسجيل الخروج',
      'welcome': 'مرحبًا',
      'invalid_email': 'أدخل بريدًا صحيحًا',
      'invalid_password': 'كلمة المرور 8+ أحرف وتحتوي رقمًا',
      'passwords_not_match': 'كلمتا المرور غير متطابقتين',
      'pull_to_refresh': 'اسحب للتحديث',
      'loading': 'جار التحميل...',
      'no_more': 'لا مزيد من العناصر',
      'as_guest': 'ضيف',
      'feed': 'الخلاصة',
      'likes': 'إعجاب',
      'comments': 'تعليق',
      'just_now': 'الآن',
      'tap_settings': 'اضغط على الإعدادات لتغيير اللغة/الثيم',
      'edit_profile': 'تعديل الملف',
      'open_design_system': 'فتح تفاصيل التصميم',
      'stories': 'القصص',
    },
  };

  String string(String key) {
    final values = _localizedValues[locale.languageCode] ??
        _localizedValues[AppLocalizations.supportedLocales.first.languageCode]!;
    return values[key] ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((e) => e.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
