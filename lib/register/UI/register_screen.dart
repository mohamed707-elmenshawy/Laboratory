import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/localization/localization.dart';
import '../../core/networking/dio_factory.dart';
import '../../login/UI/widgets/login_brand_panel.dart';
import '../../login/UI/widgets/login_layout.dart';
import '../logic/register_cubit.dart';
import 'widgets/register_email_field.dart';
import 'widgets/register_feedback_banner.dart';
import 'widgets/register_footer.dart';
import 'widgets/register_header.dart';
import 'widgets/register_name_field.dart';
import 'widgets/register_password_confirmation_field.dart';
import 'widgets/register_password_field.dart';
import 'widgets/register_submit_button.dart';
import 'widgets/register_terms_checkbox.dart';
import 'widgets/register_top_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static Route<void> route() => MaterialPageRoute<void>(
    builder: (_) => BlocProvider<RegisterCubit>(
      create: (_) => getIt<RegisterCubit>(),
      child: const RegisterScreen(),
    ),
  );

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (RegisterState previous, RegisterState current) =>
          current is RegisterSuccess,
      listener: (BuildContext context, RegisterState state) =>
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
                    RegisterTopBar(),
                    SizedBox(height: AppSpacing.x3l),
                    RegisterHeader(),
                    SizedBox(height: AppSpacing.xxl),
                    RegisterFeedbackBanner(),
                    RegisterNameField(),
                    SizedBox(height: AppSpacing.lg),
                    RegisterEmailField(),
                    SizedBox(height: AppSpacing.lg),
                    RegisterPasswordField(),
                    SizedBox(height: AppSpacing.lg),
                    RegisterPasswordConfirmationField(),
                    SizedBox(height: AppSpacing.lg),
                    RegisterTermsCheckbox(),
                    SizedBox(height: AppSpacing.xl),
                    RegisterSubmitButton(),
                    SizedBox(height: AppSpacing.xxl - 2),
                    RegisterFooter(),
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
