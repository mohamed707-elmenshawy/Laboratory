import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/register_cubit.dart';

class RegisterNameField extends StatelessWidget {
  const RegisterNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextEditingController controller = context
        .read<RegisterCubit>()
        .nameController;
    final bool enabled = context.select((RegisterCubit cubit) => !cubit.isBusy);

    return FormField<String>(
      validator: (_) => _errorFor(controller.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.nameLabel,
        hint: s.nameHint,
        controller: controller,
        prefixIcon: Icons.person_outline_rounded,
        errorText: field.hasError ? _errorFor(controller.text, s) : null,
        enabled: enabled,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        autofillHints: const <String>[AutofillHints.name],
        maxLength: 255,
        onChanged: field.didChange,
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) {
    final String name = value.trim();

    if (name.isEmpty) return s.nameRequired;
    if (name.length > 255) return s.nameTooLong;
    return null;
  }
}
