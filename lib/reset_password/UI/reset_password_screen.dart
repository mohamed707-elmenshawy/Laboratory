import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/localization/localization.dart';
import '../../core/networking/dio_factory.dart';
import '../../login/UI/widgets/login_brand_panel.dart';
import '../../login/UI/widgets/login_layout.dart';
import '../data/models/reset_password_link.dart';
import '../logic/reset_password_cubit.dart';
import 'widgets/reset_password_feedback_banner.dart';
import 'widgets/reset_password_footer.dart';
import 'widgets/reset_password_header.dart';
import 'widgets/reset_password_password_confirmation_field.dart';
import 'widgets/reset_password_password_field.dart';
import 'widgets/reset_password_submit_button.dart';
import 'widgets/reset_password_top_bar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static Route<void> route({required ResetPasswordLink link}) =>
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<ResetPasswordCubit>(
          create: (_) => getIt<ResetPasswordCubit>()..link = link,
          child: const ResetPasswordScreen(),
        ),
      );

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listenWhen: (ResetPasswordState previous, ResetPasswordState current) =>
          current is ResetPasswordSuccess,
      listener: (BuildContext context, ResetPasswordState state) =>
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
                    ResetPasswordTopBar(),
                    SizedBox(height: AppSpacing.x3l),
                    ResetPasswordHeader(),
                    SizedBox(height: AppSpacing.xxl),
                    ResetPasswordFeedbackBanner(),
                    ResetPasswordPasswordField(),
                    SizedBox(height: AppSpacing.lg),
                    ResetPasswordPasswordConfirmationField(),
                    SizedBox(height: AppSpacing.xl),
                    ResetPasswordSubmitButton(),
                    SizedBox(height: AppSpacing.xxl - 2),
                    ResetPasswordFooter(),
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
