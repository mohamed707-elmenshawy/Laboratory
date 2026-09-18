import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import 'home_destination.dart';
import 'home_soon_badge.dart';

class HomeNavItem extends StatelessWidget {
  const HomeNavItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final HomeDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool enabled = destination.isAvailable;
    final Color foreground = selected
        ? AppColors.brand700
        : (enabled ? AppColors.inkMuted : AppColors.inkFaint);

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: Material(
        color: selected ? AppColors.brandWash : Colors.transparent,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: AppRadius.mdAll,
          hoverColor: AppColors.surfaceMuted,
          child: SizedBox(
            height: AppSizes.controlMedium,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: <Widget>[
                  Icon(
                    destination.icon,
                    size: AppSizes.iconMd,
                    color: foreground,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      destination.label(s),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: base
                          .merge(AppTextStyles.label)
                          .copyWith(
                            fontSize: 14,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: foreground,
                          ),
                    ),
                  ),
                  if (!enabled) const HomeSoonBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
