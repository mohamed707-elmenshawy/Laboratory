import 'package:flutter/material.dart';

import '../../../core/localization/localization.dart';

enum HomeDestination {
  overview(Icons.space_dashboard_outlined, isAvailable: true),
  analytics(Icons.insights_outlined, isAvailable: false);

  const HomeDestination(this.icon, {required this.isAvailable});

  final IconData icon;
  final bool isAvailable;

  String label(AppStrings s) => switch (this) {
    HomeDestination.overview => s.navOverview,
    HomeDestination.analytics => s.navAnalytics,
  };
}
