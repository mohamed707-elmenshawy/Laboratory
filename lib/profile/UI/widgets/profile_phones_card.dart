import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/phone_type_option.dart';
import '../../logic/phone_draft.dart';
import '../../logic/update_profile_cubit.dart';
import 'profile_phone_row.dart';

class ProfilePhonesCard extends StatelessWidget {
  const ProfilePhonesCard({super.key, required this.phoneTypes});

  final List<PhoneTypeOption> phoneTypes;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final UpdateProfileCubit cubit = context.read<UpdateProfileCubit>();
    final bool enabled = context.select(
      (UpdateProfileCubit cubit) => !cubit.isBusy,
    );

    return AppCard(
      child: ValueListenableBuilder<List<PhoneDraft>>(
        valueListenable: cubit.phones,
        builder: (BuildContext context, List<PhoneDraft> phones, _) {
          final bool canAdd = phones.length < UpdateProfileCubit.maxPhones;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      s.phonesTitle,
                      style: base
                          .merge(AppTextStyles.label)
                          .copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                    ),
                  ),
                  Text(
                    s.phonesCount(phones.length, UpdateProfileCubit.maxPhones),
                    style: base
                        .merge(AppTextStyles.caption)
                        .copyWith(color: AppColors.inkSubtle),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                s.phonesSubtitle,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.inkSubtle),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (phones.isEmpty)
                _EmptyPhones(enabled: enabled)
              else
                for (int i = 0; i < phones.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(height: AppSpacing.lg),
                  ProfilePhoneRow(
                    key: ObjectKey(phones[i]),
                    draft: phones[i],
                    index: i,
                    phoneTypes: phoneTypes,
                  ),
                ],
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: s.addPhone,
                icon: Icons.add_rounded,
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.medium,
                onPressed: enabled && canAdd ? cubit.addPhone : null,
              ),
              if (!canAdd) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  s.phonesMaxReached(UpdateProfileCubit.maxPhones),
                  style: base
                      .merge(AppTextStyles.caption)
                      .copyWith(color: AppColors.inkSubtle),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _EmptyPhones extends StatelessWidget {
  const _EmptyPhones({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.ground,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.line, width: AppSizes.borderWidth),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.phone_outlined,
            size: AppSizes.iconMd,
            color: enabled ? AppColors.inkSubtle : AppColors.inkFaint,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              s.phonesEmpty,
              style: base
                  .merge(AppTextStyles.body)
                  .copyWith(color: AppColors.inkSubtle),
            ),
          ),
        ],
      ),
    );
  }
}
