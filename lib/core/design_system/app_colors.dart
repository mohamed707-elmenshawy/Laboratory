import 'package:flutter/widgets.dart';

abstract final class AppColors {
  static const Color brandWash = Color(0xFFE4F1F3);
  static const Color brandLine = Color(0xFFA9D5DC);
  static const Color brand500 = Color(0xFF128A9F);

  static const Color brand600 = Color(0xFF0E7285);
  static const Color brand700 = Color(0xFF0B5B6B);
  static const Color brand800 = Color(0xFF0A4F5D);
  static const Color brand900 = Color(0xFF062E38);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color ground = Color(0xFFF4F7F8);
  static const Color surfaceMuted = Color(0xFFEAF0F1);
  static const Color surfaceSunken = Color(0xFFE1E9EB);

  static const Color line = Color(0xFFDAE4E6);
  static const Color lineStrong = Color(0xFFC1D0D3);

  static const Color ink = Color(0xFF101B20);
  static const Color inkMuted = Color(0xFF3A4A51);

  static const Color inkSubtle = Color(0xFF63767D);

  static const Color inkFaint = Color(0xFF8B9AA0);

  static const Color onBrand = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF0A6E4C);
  static const Color successWash = Color(0xFFE4F2EC);
  static const Color successLine = Color(0xFFB7DECB);

  static const Color warning = Color(0xFF8A5D06);
  static const Color warningWash = Color(0xFFFAF1DD);
  static const Color warningLine = Color(0xFFE6D2A4);

  static const Color danger = Color(0xFFB33A30);
  static const Color dangerWash = Color(0xFFFAEBE9);
  static const Color dangerLine = Color(0xFFEDC4BF);

  static const Color info = brand600;
  static const Color infoWash = brandWash;
  static const Color infoLine = brandLine;

  static const Color focusRing = Color(0x290E7285);

  static const Color dangerRing = Color(0x21B33A30);

  static const Color onBrandPanel = Color(0xFFFFFFFF);

  static const LinearGradient brandPanel = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: <double>[0.0, 0.46, 1.0],
    colors: <Color>[brand600, brand800, brand900],
  );
}
