import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../../terms/UI/terms_dialog.dart';
import '../../logic/register_cubit.dart';

class RegisterTermsCheckbox extends StatefulWidget {
  const RegisterTermsCheckbox({super.key});

  @override
  State<RegisterTermsCheckbox> createState() => _RegisterTermsCheckboxState();
}

class _RegisterTermsCheckboxState extends State<RegisterTermsCheckbox> {
  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final RegisterCubit cubit = context.read<RegisterCubit>();
    final bool enabled = context.select((RegisterCubit cubit) => !cubit.isBusy);

    return FormField<bool>(
      initialValue: cubit.acceptedTerms,
      validator: (bool? value) => (value ?? false) ? null : s.termsRequired,
      builder: (FormFieldState<bool> field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              AppCheckbox(
                value: cubit.acceptedTerms,
                label: s.termsAgreePrefix,
                semanticLabel: s.termsLabel,
                semanticHint: s.termsHint,
                onChanged: enabled
                    ? (bool value) {
                        setState(() => cubit.acceptedTerms = value);
                        field.didChange(value);
                      }
                    : null,
              ),
              AppTextLink(
                label: s.termsTitle,
                onPressed: enabled ? () => TermsDialog.show(context) : null,
              ),
            ],
          ),
          if (field.hasError) ...<Widget>[
            const SizedBox(height: AppSpacing.xs + 2),
            Semantics(
              liveRegion: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: AppSizes.iconSm,
                      color: AppColors.danger,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs + 2),
                  Expanded(
                    child: Text(
                      field.errorText!,
                      style: base
                          .merge(AppTextStyles.caption)
                          .copyWith(fontSize: 12.5, color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
