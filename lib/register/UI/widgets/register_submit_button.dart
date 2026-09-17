import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/register_cubit.dart';

class RegisterSubmitButton extends StatelessWidget {
  const RegisterSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final RegisterState state = context.watch<RegisterCubit>().state;

    return AppButton(
      label: s.createAccount,
      loadingLabel: s.creatingAccount,
      successLabel: s.accountCreated,
      expand: true,
      size: AppButtonSize.large,
      isLoading: state is RegisterLoading,
      isSuccess: state is RegisterSuccess,
      onPressed: context.read<RegisterCubit>().isBusy
          ? null
          : () {
              if (Form.of(context).validate()) {
                context.read<RegisterCubit>().register();
              }
            },
    );
  }
}
