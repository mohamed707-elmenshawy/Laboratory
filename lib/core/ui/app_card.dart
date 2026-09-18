import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_sizes.dart';
import '../design_system/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xxl),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.line, width: AppSizes.borderWidth),
      ),
      child: child,
    );
  }
}
