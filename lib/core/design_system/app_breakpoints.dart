import 'package:flutter/widgets.dart';

enum LayoutSize {
  compact,

  medium,

  expanded;

  bool get isMedium => this == LayoutSize.medium;
  bool get isExpanded => this == LayoutSize.expanded;
}

abstract final class AppBreakpoints {
  static const double medium = 768;
  static const double expanded = 1240;

  static LayoutSize of(double width) {
    if (width >= expanded) return LayoutSize.expanded;
    if (width >= medium) return LayoutSize.medium;
    return LayoutSize.compact;
  }
}

extension LayoutSizeX on BuildContext {
  LayoutSize get layoutSize => AppBreakpoints.of(MediaQuery.sizeOf(this).width);
}
