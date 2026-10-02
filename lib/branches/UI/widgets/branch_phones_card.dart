import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/phones/phones.dart';
import '../../../core/ui/ui.dart';
import '../../logic/update_branch_cubit.dart';

class BranchPhonesCard extends StatelessWidget {
  const BranchPhonesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final UpdateBranchCubit cubit = context.read<UpdateBranchCubit>();
    final bool enabled = context.select(
      (UpdateBranchCubit cubit) => !cubit.isBusy,
    );
    final AppError? error = context.select(
      (UpdateBranchCubit cubit) => switch (cubit.state) {
        UpdateBranchFailure(:final AppError error) => error,
        _ => null,
      },
    );

    return AppCard(
      child: ValueListenableBuilder<List<PhoneDraft>>(
        valueListenable: cubit.phones,
        builder: (BuildContext context, List<PhoneDraft> phones, _) {
          final bool canAdd = phones.length < UpdateBranchCubit.maxPhones;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      s.branchPhonesLabel,
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
                    s.phonesCount(phones.length, UpdateBranchCubit.maxPhones),
                    style: base
                        .merge(AppTextStyles.caption)
                        .copyWith(color: AppColors.inkSubtle),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              if (phones.isEmpty)
                _Empty(enabled: enabled)
              else
                for (int i = 0; i < phones.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(height: AppSpacing.lg),
                  PhoneInputRow(
                    key: ObjectKey(phones[i]),
                    draft: phones[i],
                    index: i,
                    phoneTypes: const <PhoneTypeOption>[],
                    enabled: enabled,
                    serverErrorFor: (String key) => error?.fieldError(key),
                    validator: () => _validate(cubit, phones[i], s),
                    onCountryChanged: (String value) =>
                        cubit.setPhoneCountry(phones[i], value),
                    onTypeChanged: (String value) =>
                        cubit.setPhoneType(phones[i], value),
                    onEdited: cubit.fieldEdited,
                    onRemove: () => cubit.removePhone(phones[i]),
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
                  s.phonesMaxReached(UpdateBranchCubit.maxPhones),
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

  String? _validate(UpdateBranchCubit cubit, PhoneDraft draft, AppStrings s) {
    final String value = draft.phone;

    if (value.isEmpty) return s.phoneRequired;
    if (value.length < 6) return s.phoneInvalid;
    if (cubit.duplicatePhone(draft) != null) return s.phoneDuplicate;
    return null;
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.enabled});

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
