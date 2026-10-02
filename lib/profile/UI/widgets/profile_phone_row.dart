import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../../core/phones/phones.dart';
import '../../logic/update_profile_cubit.dart';

class ProfilePhoneRow extends StatelessWidget {
  const ProfilePhoneRow({
    super.key,
    required this.draft,
    required this.index,
    required this.phoneTypes,
  });

  static const double _stackFrom = 560;
  static const double _countryWidth = 140;
  static const double _typeWidth = 168;

  final PhoneDraft draft;
  final int index;
  final List<PhoneTypeOption> phoneTypes;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UpdateProfileCubit cubit = context.read<UpdateProfileCubit>();
    final bool enabled = context.select(
      (UpdateProfileCubit cubit) => !cubit.isBusy,
    );

    final AppError? error = context.select(
      (UpdateProfileCubit cubit) => switch (cubit.state) {
        UpdateProfileFailure(:final AppError error) => error,
        _ => null,
      },
    );

    final Widget country = AppSelect<String>(
      label: s.phoneCountryLabel,
      value: draft.country,
      enabled: enabled,
      errorText: error?.fieldError('phones.$index.phone_country'),
      options: PhoneCountry.withCode(draft.country, dialCode: draft.dialCode)
          .map(
            (PhoneCountry item) => AppSelectOption<String>(
              value: item.code,
              label: '${item.flag}  ${item.dialCode}',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(item.flag),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      item.dialCode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(growable: false),
      onChanged: (String value) => cubit.setCountry(draft, value),
    );

    final String? serverError = error?.fieldError('phones.$index.phone');

    final Widget number = FormField<String>(
      validator: (_) => _errorFor(context, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.phoneNumberLabel,
        hint: s.phoneNumberHint,
        controller: draft.controller,
        prefixIcon: Icons.phone_outlined,
        enabled: enabled,
        textDirection: TextDirection.ltr,
        keyboardType: TextInputType.phone,
        maxLength: 20,
        semanticLabel: s.phoneNumberOf(index + 1),
        errorText: field.hasError ? _errorFor(context, s) : serverError,
        onChanged: (String value) {
          cubit.phoneEdited();
          field.didChange(value);
        },
      ),
    );

    final List<PhoneTypeOption> types = _typeOptions(s);

    final Widget type = AppSelect<String>(
      label: s.phoneTypeLabel,
      value: _typeValue(types),
      enabled: enabled,
      errorText: error?.fieldError('phones.$index.type'),
      options: types
          .map(
            (PhoneTypeOption item) =>
                AppSelectOption<String>(value: item.value, label: item.label),
          )
          .toList(growable: false),
      onChanged: (String value) => cubit.setType(draft, value),
    );

    final bool isNew = draft.id == null;

    final Widget cancel = _CancelButton(
      tooltip: s.cancelPhone,
      onPressed: enabled ? () => cubit.removePhone(draft) : null,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < _stackFrom) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(width: _countryWidth, child: country),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: type),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: number),
                  if (isNew) ...<Widget>[
                    const SizedBox(width: AppSpacing.sm),
                    cancel,
                  ],
                ],
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: _countryWidth, child: country),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: number),
            const SizedBox(width: AppSpacing.md),
            SizedBox(width: _typeWidth, child: type),
            if (isNew) ...<Widget>[
              const SizedBox(width: AppSpacing.sm),
              cancel,
            ],
          ],
        );
      },
    );
  }

  List<PhoneTypeOption> _typeOptions(AppStrings s) =>
      phoneTypes.isNotEmpty ? phoneTypes : PhoneTypeOption.defaults(s);

  String _typeValue(List<PhoneTypeOption> options) {
    for (final PhoneTypeOption option in options) {
      if (option.value == draft.type) return draft.type;
    }
    return options.first.value;
  }

  String? _errorFor(BuildContext context, AppStrings s) {
    final UpdateProfileCubit cubit = context.read<UpdateProfileCubit>();
    final String value = draft.phone;

    if (value.isEmpty) return s.phoneRequired;
    if (value.length < 6) return s.phoneInvalid;
    if (cubit.duplicateOf(draft) != null) return s.phoneDuplicate;
    return null;
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxl + 2),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        iconSize: AppSizes.iconMd,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(
          width: AppSizes.hitTarget,
          height: AppSizes.hitTarget,
        ),
        hoverColor: AppColors.surfaceMuted,
        disabledColor: AppColors.inkFaint,
        icon: const Icon(Icons.close_rounded, color: AppColors.inkSubtle),
      ),
    );
  }
}
