import 'package:flutter/widgets.dart';

import 'app_sizes.dart';

abstract final class AppShadows {
  static const List<BoxShadow> none = <BoxShadow>[];

  static const List<BoxShadow> e1 = <BoxShadow>[
    BoxShadow(color: Color(0x0F101B20), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x1A101B20), blurRadius: 34, offset: Offset(0, 12)),
  ];

  static const List<BoxShadow> e2 = <BoxShadow>[
    BoxShadow(color: Color(0x29101B20), blurRadius: 28, offset: Offset(0, 8)),
  ];

  static List<BoxShadow> focusRing(Color color) => <BoxShadow>[
    BoxShadow(color: color, spreadRadius: AppSizes.focusRingWidth),
  ];
}
