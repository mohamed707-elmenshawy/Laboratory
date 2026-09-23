import 'dart:ui' show TextDirection;

class AppLocale {
  const AppLocale({
    required this.code,
    required this.nativeName,
    required this.isRtl,
  });

  static const AppLocale en = AppLocale(
    code: 'en',
    nativeName: 'English',
    isRtl: false,
  );

  static const AppLocale ar = AppLocale(
    code: 'ar',
    nativeName: 'العربية',
    isRtl: true,
  );

  static const List<AppLocale> values = <AppLocale>[en, ar];

  static const Map<String, String> _nativeNames = <String, String>{
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'de': 'Deutsch',
    'es': 'Español',
    'it': 'Italiano',
    'tr': 'Türkçe',
    'fa': 'فارسی',
    'he': 'עברית',
    'ur': 'اردو',
  };

  static const Set<String> _rtl = <String>{'ar', 'fa', 'he', 'ur'};

  final String code;
  final String nativeName;
  final bool isRtl;

  String get headerCode => code.toUpperCase();

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  static AppLocale? tryParse(String? code) {
    if (code == null || code.isEmpty) return null;

    final String language = _languageOf(code);
    if (language.isEmpty) return null;
    if (language == en.code) return en;
    if (language == ar.code) return ar;

    return AppLocale(
      code: language,
      nativeName: _nativeNames[language] ?? language.toUpperCase(),
      isRtl: _rtl.contains(language),
    );
  }

  static String _languageOf(String code) {
    final String normalized = code.trim().toLowerCase();
    final int separator = normalized.indexOf(RegExp('[-_]'));
    return separator == -1 ? normalized : normalized.substring(0, separator);
  }

  @override
  bool operator ==(Object other) => other is AppLocale && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
