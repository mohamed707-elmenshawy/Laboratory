import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/profile_model.dart';
import 'profile_email_field.dart';
import 'profile_name_field.dart';

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              AppAvatar(name: profile.name, size: 56),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: base
                          .merge(AppTextStyles.h3)
                          .copyWith(color: AppColors.ink),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                      style: base
                          .merge(AppTextStyles.body)
                          .copyWith(color: AppColors.inkSubtle),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Divider(height: 1, thickness: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            s.personalDetailsTitle,
            style: base
                .merge(AppTextStyles.label)
                .copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const ProfileNameField(),
          const SizedBox(height: AppSpacing.lg),
          ProfileEmailField(email: profile.email),
        ],
      ),
    );
  }
}
