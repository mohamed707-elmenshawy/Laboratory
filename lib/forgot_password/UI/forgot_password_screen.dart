import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/localization/localization.dart';
import '../../core/networking/dio_factory.dart';
import '../../login/UI/widgets/login_brand_panel.dart';
import '../../login/UI/widgets/login_layout.dart';
import '../logic/forgot_password_cubit.dart';
import 'widgets/forgot_password_email_field.dart';
import 'widgets/forgot_password_feedback_banner.dart';
import 'widgets/forgot_password_footer.dart';
import 'widgets/forgot_password_header.dart';
import 'widgets/forgot_password_submit_button.dart';
import 'widgets/forgot_password_top_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static Route<void> route({String email = ''}) => MaterialPageRoute<void>(
    builder: (_) => BlocProvider<ForgotPasswordCubit>(
      create: (_) => getIt<ForgotPasswordCubit>()..emailController.text = email,
      child: const ForgotPasswordScreen(),
    ),
  );

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AppLocale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final AppLocale locale = context.appLocale;
    if (locale == _locale) return;

    _locale = locale;
    DioFactory.setLocale(locale.code);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (ForgotPasswordState previous, ForgotPasswordState current) =>
          current is ForgotPasswordSuccess,
      listener: (BuildContext context, ForgotPasswordState state) =>
          TextInput.finishAutofillContext(),
      child: Scaffold(
        backgroundColor: context.layoutSize.isMedium
            ? AppColors.ground
            : AppColors.surface,
        body: FocusTraversalGroup(
          child: const LoginLayout(
            brandPanel: LoginBrandPanel(),
            formPane: Form(
              autovalidateMode: AutovalidateMode.onUserInteractionIfError,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ForgotPasswordTopBar(),
                    SizedBox(height: AppSpacing.x3l),
                    ForgotPasswordHeader(),
                    SizedBox(height: AppSpacing.xxl),
                    ForgotPasswordFeedbackBanner(),
                    ForgotPasswordEmailField(),
                    SizedBox(height: AppSpacing.xl),
                    ForgotPasswordSubmitButton(),
                    SizedBox(height: AppSpacing.xxl - 2),
                    ForgotPasswordFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
