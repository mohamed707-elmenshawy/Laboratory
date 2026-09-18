import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/verification_cubit.dart';

class VerificationSubmitButton extends StatelessWidget {
  const VerificationSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final VerificationState state = context.watch<VerificationCubit>().state;

    return AppButton(
      label: s.verifyEmailAction,
      loadingLabel: s.verifying,
      successLabel: s.verified,
      expand: true,
      size: AppButtonSize.large,
      isLoading: state is VerificationLoading,
      isSuccess: state is VerificationSuccess,
      onPressed: context.read<VerificationCubit>().isBusy
          ? null
          : () {
              if (Form.of(context).validate()) {
                context.read<VerificationCubit>().verify();
              }
            },
    );
  }
}
