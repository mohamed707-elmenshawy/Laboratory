import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/update_profile_cubit.dart';

class ProfileNameField extends StatelessWidget {
  const ProfileNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextEditingController controller = context
        .read<UpdateProfileCubit>()
        .nameController;
    final bool enabled = context.select(
      (UpdateProfileCubit cubit) => !cubit.isBusy,
    );

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
        textInputAction: TextInputAction.done,
        autofillHints: const <String>[AutofillHints.name],
        maxLength: 255,
        onSubmitted: (_) {
          if (Form.of(context).validate()) {
            context.read<UpdateProfileCubit>().save();
          }
        },
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
