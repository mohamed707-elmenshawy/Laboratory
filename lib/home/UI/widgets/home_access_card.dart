import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/models/user_model.dart';
import '../../../core/ui/ui.dart';

class HomeAccessCard extends StatelessWidget {
  const HomeAccessCard({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    final (String scope, String description) = user.isCentralAdmin
        ? (s.scopeCentral, s.scopeCentralDescription)
        : user.isBranchScoped
        ? (s.scopeBranch, s.scopeBranchDescription)
        : (s.scopeLaboratory, s.scopeLaboratoryDescription);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.brandWash,
                  borderRadius: AppRadius.mdAll,
                ),
                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  size: AppSizes.iconLg,
                  color: AppColors.brand700,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      s.accessTitle,
                      style: base
                          .merge(AppTextStyles.caption)
                          .copyWith(color: AppColors.inkSubtle),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scope,
                      style: base
                          .merge(AppTextStyles.h3)
                          .copyWith(fontSize: 16, color: AppColors.ink),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            description,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(height: 1, thickness: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.lg),
          Text(
            s.signedInAsLabel,
            style: base
                .merge(AppTextStyles.caption)
                .copyWith(color: AppColors.inkSubtle),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            user.email,
            textDirection: TextDirection.ltr,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(fontWeight: FontWeight.w500, color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}
