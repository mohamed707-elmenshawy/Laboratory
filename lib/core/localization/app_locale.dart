import 'dart:ui' show TextDirection;

enum AppLocale {
  en(code: 'en', nativeName: 'English', isRtl: false),
  ar(code: 'ar', nativeName: 'العربية', isRtl: true);

  const AppLocale({
    required this.code,
    required this.nativeName,
    required this.isRtl,
  });

  final String code;
  final String nativeName;
  final bool isRtl;

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;
}
