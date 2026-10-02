import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import '../localization/localization.dart';
import '../phones/phones.dart';
import 'app_select.dart';
import 'app_text_field.dart';

class PhoneInputRow extends StatelessWidget {
  const PhoneInputRow({
    super.key,
    required this.draft,
    required this.index,
    required this.phoneTypes,
    required this.enabled,
    required this.onCountryChanged,
    required this.onTypeChanged,
    required this.onEdited,
    required this.validator,
    this.serverErrorFor,
    this.onRemove,
    this.removeTooltip,
  });

  static const double _stackFrom = 560;
  static const double _countryWidth = 140;
  static const double _typeWidth = 168;

  final PhoneDraft draft;
  final int index;
  final List<PhoneTypeOption> phoneTypes;
  final bool enabled;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onEdited;
  final String? Function() validator;
  final String? Function(String key)? serverErrorFor;
  final VoidCallback? onRemove;
  final String? removeTooltip;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    final Widget country = AppSelect<String>(
      label: s.phoneCountryLabel,
      value: draft.country,
      enabled: enabled,
      errorText: _serverError('phones.$index.phone_country'),
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
      onChanged: onCountryChanged,
    );

    final String? numberServerError = _serverError('phones.$index.phone');

    final Widget number = FormField<String>(
      validator: (_) => validator(),
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
        errorText: field.hasError ? validator() : numberServerError,
        onChanged: (String value) {
          onEdited();
          field.didChange(value);
        },
      ),
    );

    final List<PhoneTypeOption> types = phoneTypes.isNotEmpty
        ? phoneTypes
        : PhoneTypeOption.defaults(s);

    final Widget type = AppSelect<String>(
      label: s.phoneTypeLabel,
      value: _typeValue(types),
      enabled: enabled,
      errorText: _serverError('phones.$index.type'),
      options: types
          .map(
            (PhoneTypeOption item) =>
                AppSelectOption<String>(value: item.value, label: item.label),
          )
          .toList(growable: false),
      onChanged: onTypeChanged,
    );

    final Widget? remove = onRemove == null
        ? null
        : _RemoveButton(
            tooltip: removeTooltip ?? s.removePhone,
            onPressed: enabled ? onRemove : null,
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
                  if (remove != null) ...<Widget>[
                    const SizedBox(width: AppSpacing.sm),
                    remove,
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
            if (remove != null) ...<Widget>[
              const SizedBox(width: AppSpacing.sm),
              remove,
            ],
          ],
        );
      },
    );
  }

  String? _serverError(String key) => serverErrorFor?.call(key);

  String _typeValue(List<PhoneTypeOption> options) {
    for (final PhoneTypeOption option in options) {
      if (option.value == draft.type) return draft.type;
    }
    return options.first.value;
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.tooltip, required this.onPressed});

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
        hoverColor: AppColors.dangerWash,
        disabledColor: AppColors.inkFaint,
        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
      ),
    );
  }
}
