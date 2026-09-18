import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/reset_password_cubit.dart';

class ResetPasswordPasswordField extends StatelessWidget {
  const ResetPasswordPasswordField({super.key});

  static const int minLength = 8;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextEditingController controller = context
        .read<ResetPasswordCubit>()
        .passwordController;
    final bool enabled = context.select(
      (ResetPasswordCubit cubit) => !cubit.isBusy,
    );

    return FormField<String>(
      validator: (_) => _errorFor(controller.text, s),
      builder: (FormFieldState<String> field) => AppPasswordField(
        label: s.newPasswordLabel,
        hint: s.newPasswordHint,
        showPasswordLabel: s.showPassword,
        hidePasswordLabel: s.hidePassword,
        controller: controller,
        errorText: field.hasError ? _errorFor(controller.text, s) : null,
        enabled: enabled,
        textInputAction: TextInputAction.next,
        autofillHints: const <String>[AutofillHints.newPassword],
        onChanged: field.didChange,
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) {
    if (value.isEmpty) return s.passwordRequired;
    if (value.length < minLength) return s.passwordTooShort;
    return null;
  }
}
