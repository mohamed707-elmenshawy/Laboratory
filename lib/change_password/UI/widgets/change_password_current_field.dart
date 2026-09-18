import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/change_password_cubit.dart';

class ChangePasswordCurrentField extends StatelessWidget {
  const ChangePasswordCurrentField({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextEditingController controller = context
        .read<ChangePasswordCubit>()
        .currentPasswordController;
    final bool enabled = context.select(
      (ChangePasswordCubit cubit) => !cubit.isBusy,
    );

    return FormField<String>(
      validator: (_) => _errorFor(controller.text, s),
      builder: (FormFieldState<String> field) => AppPasswordField(
        label: s.currentPasswordLabel,
        hint: s.currentPasswordHint,
        showPasswordLabel: s.showPassword,
        hidePasswordLabel: s.hidePassword,
        controller: controller,
        errorText: field.hasError ? _errorFor(controller.text, s) : null,
        enabled: enabled,
        textInputAction: TextInputAction.next,
        autofillHints: const <String>[AutofillHints.password],
        onChanged: field.didChange,
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) =>
      value.isEmpty ? s.currentPasswordRequired : null;
}
