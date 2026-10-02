import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';

class BranchesHeader extends StatelessWidget {
  const BranchesHeader({
    super.key,
    required this.onRefresh,
    required this.onCreate,
  });

  static const double _stackFrom = 560;

  final VoidCallback onRefresh;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    final Widget titles = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          s.branchesTitle,
          style: base.merge(AppTextStyles.h2).copyWith(color: AppColors.ink),
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        Text(
          s.branchesSubtitle,
          style: base
              .merge(AppTextStyles.body)
              .copyWith(color: AppColors.inkSubtle),
        ),
      ],
    );

    final Widget actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          onPressed: onRefresh,
          tooltip: s.refresh,
          iconSize: AppSizes.iconMd,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(
            width: AppSizes.hitTarget,
            height: AppSizes.hitTarget,
          ),
          hoverColor: AppColors.brandWash,
          icon: const Icon(Icons.refresh_rounded, color: AppColors.inkMuted),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppButton(
          label: s.newBranch,
          size: AppButtonSize.medium,
          icon: Icons.add_rounded,
          onPressed: onCreate,
        ),
      ],
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < _stackFrom) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titles,
              const SizedBox(height: AppSpacing.lg),
              actions,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: titles),
            const SizedBox(width: AppSpacing.lg),
            actions,
          ],
        );
      },
    );
  }
}
