import 'package:flutter/widgets.dart';

abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);

  static const Duration base = Duration(milliseconds: 180);

  static const Duration slow = Duration(milliseconds: 220);

  static const Curve curve = Curves.easeOut;

  static Duration resolve(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
