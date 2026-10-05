import 'package:flutter/material.dart';

import '../../../core/localization/localization.dart';

enum HomeDestination {
  overview(Icons.space_dashboard_outlined, isAvailable: true),
  branches(Icons.store_mall_directory_outlined, isAvailable: true),
  testCategories(Icons.science_outlined, isAvailable: true),
  sampleTypes(Icons.biotech_outlined, isAvailable: true),
  units(Icons.straighten_rounded, isAvailable: true),
  analytics(Icons.insights_outlined, isAvailable: false),
  profile(Icons.person_outline_rounded, isAvailable: true, inNav: false),
  changePassword(Icons.lock_reset_rounded, isAvailable: true, inNav: false);

  const HomeDestination(
    this.icon, {
    required this.isAvailable,
    this.inNav = true,
  });

  final IconData icon;
  final bool isAvailable;
  final bool inNav;

  String label(AppStrings s) => switch (this) {
    HomeDestination.overview => s.navOverview,
    HomeDestination.branches => s.navBranches,
    HomeDestination.testCategories => s.navTestCategories,
    HomeDestination.sampleTypes => s.navSampleTypes,
    HomeDestination.units => s.navUnits,
    HomeDestination.analytics => s.navAnalytics,
    HomeDestination.profile => s.profileTitle,
    HomeDestination.changePassword => s.changePassword,
  };
}
