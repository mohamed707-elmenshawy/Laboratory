import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/register_cubit.dart';

class RegisterEmailField extends StatelessWidget {
  const RegisterEmailField({super.key});

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextEditingController controller = context
        .read<RegisterCubit>()
        .emailController;
    final bool enabled = context.select((RegisterCubit cubit) => !cubit.isBusy);

    return FormField<String>(
      validator: (_) => _errorFor(controller.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.emailLabel,
        hint: s.emailHint,
        controller: controller,
        prefixIcon: Icons.mail_outline_rounded,
        errorText: field.hasError ? _errorFor(controller.text, s) : null,
        enabled: enabled,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const <String>[AutofillHints.email],
        textDirection: TextDirection.ltr,
        maxLength: 255,
        onChanged: field.didChange,
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) {
    final String email = value.trim();

    if (email.isEmpty) return s.emailRequired;
    if (email.length > 255) return s.emailTooLong;
    if (!_emailPattern.hasMatch(email)) return s.emailInvalid;
    return null;
  }
}
