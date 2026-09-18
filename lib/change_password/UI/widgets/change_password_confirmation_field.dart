import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/change_password_cubit.dart';

class ChangePasswordConfirmationField extends StatelessWidget {
  const ChangePasswordConfirmationField({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final ChangePasswordCubit cubit = context.read<ChangePasswordCubit>();
    final bool enabled = context.select(
      (ChangePasswordCubit cubit) => !cubit.isBusy,
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit, s),
      builder: (FormFieldState<String> field) => AppPasswordField(
        label: s.passwordConfirmationLabel,
        hint: s.passwordConfirmationHint,
        showPasswordLabel: s.showPassword,
        hidePasswordLabel: s.hidePassword,
        controller: cubit.passwordConfirmationController,
        errorText: field.hasError ? _errorFor(cubit, s) : null,
        enabled: enabled,
        textInputAction: TextInputAction.done,
        autofillHints: const <String>[AutofillHints.newPassword],
        onSubmitted: (_) {
          if (Form.of(context).validate()) {
            context.read<ChangePasswordCubit>().changePassword();
          }
        },
        onChanged: field.didChange,
      ),
    );
  }

  static String? _errorFor(ChangePasswordCubit cubit, AppStrings s) {
    final String confirmation = cubit.passwordConfirmationController.text;

    if (confirmation.isEmpty) return s.passwordConfirmationRequired;
    if (confirmation != cubit.passwordController.text) {
      return s.passwordMismatch;
    }
    return null;
  }
}
