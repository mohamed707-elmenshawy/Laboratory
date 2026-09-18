import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/update_profile_cubit.dart';

class ProfileSaveButton extends StatelessWidget {
  const ProfileSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool busy = context.select(
      (UpdateProfileCubit cubit) => cubit.isBusy,
    );

    return AppButton(
      label: s.saveChanges,
      loadingLabel: s.savingChanges,
      size: AppButtonSize.medium,
      isLoading: busy,
      onPressed: busy
          ? null
          : () {
              if (Form.of(context).validate()) {
                context.read<UpdateProfileCubit>().save();
              }
            },
    );
  }
}
