import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/login_cubit.dart';
import '../../logic/login_state.dart';
import 'login_field_error_text.dart';

class LoginPasswordField extends StatefulWidget {
  const LoginPasswordField({super.key});

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
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
      (LoginCubit cubit) => cubit.passwordController,
    );
    final LoginFieldError? error = context.select(
      (LoginCubit cubit) => cubit.state.passwordError,
    );
    final bool enabled = context.select(
      (LoginCubit cubit) => cubit.state.canSubmit,
    );

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (LoginState previous, LoginState current) =>
          previous.status != current.status &&
          current.status == LoginStatus.failure &&
          current.emailError == null &&
          current.passwordError != null,
      listener: (BuildContext context, LoginState state) =>
          _focusNode.requestFocus(),
      child: AppPasswordField(
        label: s.passwordLabel,
        hint: s.passwordHint,
        showPasswordLabel: s.showPassword,
        hidePasswordLabel: s.hidePassword,
        controller: controller,
        focusNode: _focusNode,
        errorText: error?.localized(s),
        enabled: enabled,
        textInputAction: TextInputAction.done,
        autofillHints: const <String>[AutofillHints.password],
        onSubmitted: (_) => context.read<LoginCubit>().submit(),
        onChanged: (_) => context.read<LoginCubit>().onPasswordChanged(),
      ),
    );
  }
}
