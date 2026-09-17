import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/login_cubit.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextEditingController controller = context
        .read<LoginCubit>()
        .passwordController;
    final bool enabled = context.select((LoginCubit cubit) => !cubit.isBusy);

    return FormField<String>(
      validator: (_) => controller.text.isEmpty ? s.passwordRequired : null,
      builder: (FormFieldState<String> field) => AppPasswordField(
        label: s.passwordLabel,
        hint: s.passwordHint,
        showPasswordLabel: s.showPassword,
        hidePasswordLabel: s.hidePassword,
        controller: controller,
        errorText: field.hasError ? s.passwordRequired : null,
        enabled: enabled,
        textInputAction: TextInputAction.done,
        autofillHints: const <String>[AutofillHints.password],
        onSubmitted: (_) {
          if (Form.of(context).validate()) context.read<LoginCubit>().login();
        },
        onChanged: field.didChange,
      ),
    );
  }
}
