import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/login_cubit.dart';
import '../../logic/login_state.dart';
import 'login_field_error_text.dart';

class LoginEmailField extends StatefulWidget {
  const LoginEmailField({super.key});

  @override
  State<LoginEmailField> createState() => _LoginEmailFieldState();
}

class _LoginEmailFieldState extends State<LoginEmailField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextEditingController controller = context.select(
      (LoginCubit cubit) => cubit.emailController,
    );
    final LoginFieldError? error = context.select(
      (LoginCubit cubit) => cubit.state.emailError,
    );
    final bool enabled = context.select(
      (LoginCubit cubit) => cubit.state.canSubmit,
    );

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (LoginState previous, LoginState current) =>
          previous.status != current.status &&
          current.status == LoginStatus.failure &&
          current.emailError != null,
      listener: (BuildContext context, LoginState state) =>
          _focusNode.requestFocus(),
      child: AppTextField(
        label: s.emailLabel,
        hint: s.emailHint,
        controller: controller,
        focusNode: _focusNode,
        prefixIcon: Icons.mail_outline_rounded,
        errorText: error?.localized(s),
        enabled: enabled,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const <String>[
          AutofillHints.username,
          AutofillHints.email,
        ],
        textDirection: TextDirection.ltr,
        maxLength: 255,
        onChanged: (_) => context.read<LoginCubit>().onEmailChanged(),
      ),
    );
  }
}
