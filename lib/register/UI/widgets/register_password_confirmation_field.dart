import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/register_cubit.dart';

class RegisterPasswordConfirmationField extends StatelessWidget {
  const RegisterPasswordConfirmationField({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final RegisterCubit cubit = context.read<RegisterCubit>();
    final bool enabled = context.select((RegisterCubit cubit) => !cubit.isBusy);

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
          if (Form.of(context).validate())
            context.read<RegisterCubit>().register();
        },
        onChanged: field.didChange,
      ),
    );
  }

  static String? _errorFor(RegisterCubit cubit, AppStrings s) {
    final String confirmation = cubit.passwordConfirmationController.text;

    if (confirmation.isEmpty) return s.passwordConfirmationRequired;
    if (confirmation != cubit.passwordController.text)
      return s.passwordMismatch;
    return null;
  }
}
