import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import 'home_destination.dart';
import 'home_nav_item.dart';

class HomeSidebar extends StatelessWidget {
  const HomeSidebar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final HomeDestination selected;
  final ValueChanged<HomeDestination> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Container(
      width: AppSizes.sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: BorderDirectional(end: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: AppSizes.appBarHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            alignment: AlignmentDirectional.centerStart,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: AppLogoLockup(
              productName: s.productName,
              tagline: s.productTagline,
              onDark: false,
              markSize: 32,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: Text(
                    s.navSectionWorkspace.toUpperCase(),
                    style: base
                        .merge(AppTextStyles.caption)
                        .copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                          color: AppColors.inkFaint,
                        ),
                  ),
                ),
                for (final HomeDestination destination
                    in HomeDestination.values) ...<Widget>[
                  HomeNavItem(
                    destination: destination,
                    selected: destination == selected,
                    onTap: () => onSelected(destination),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
