import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/verification_cubit.dart';

class VerificationCodeField extends StatelessWidget {
  const VerificationCodeField({super.key});

  static const int codeLength = 6;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextEditingController controller = context
        .read<VerificationCubit>()
        .codeController;
    final bool enabled = context.select(
      (VerificationCubit cubit) => !cubit.isBusy,
    );

    return FormField<String>(
      validator: (_) => _errorFor(controller.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.codeLabel,
        hint: s.codeHint,
        controller: controller,
        prefixIcon: Icons.pin_outlined,
        errorText: field.hasError ? _errorFor(controller.text, s) : null,
        enabled: enabled,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        autofillHints: const <String>[AutofillHints.oneTimeCode],
        textDirection: TextDirection.ltr,
        maxLength: codeLength,
        onSubmitted: (_) {
          if (Form.of(context).validate()) {
            context.read<VerificationCubit>().verify();
          }
        },
        onChanged: field.didChange,
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) {
    final String code = value.trim();

    if (code.isEmpty) return s.codeRequired;
    if (code.length != codeLength) return s.codeLength;
    return null;
  }
}
