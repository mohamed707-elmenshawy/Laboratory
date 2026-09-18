import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laboratory/login/UI/widgets/login_brand_panel.dart';
import 'package:laboratory/login/UI/widgets/login_feedback_banner.dart';
import 'package:laboratory/login/UI/widgets/login_footer.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/localization/localization.dart';
import '../../core/networking/dio_factory.dart';
import '../../home/UI/home_screen.dart';
import '../logic/login_cubit.dart';
import 'widgets/login_email_field.dart';
import 'widgets/login_header.dart';
import 'widgets/login_layout.dart';
import 'widgets/login_options_row.dart';
import 'widgets/login_password_field.dart';
import 'widgets/login_submit_button.dart';
import 'widgets/login_top_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Route<void> route() => MaterialPageRoute<void>(
    builder: (_) => BlocProvider<LoginCubit>(
      create: (_) => getIt<LoginCubit>(),
      child: const LoginScreen(),
    ),
  );

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (LoginState previous, LoginState current) =>
          current is LoginSuccess,
      listener: (BuildContext context, LoginState state) {
        TextInput.finishAutofillContext();
        Navigator.of(
          context,
        ).pushAndRemoveUntil(HomeScreen.route(), (Route<dynamic> _) => false);
      },
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
                    LoginTopBar(),
                    SizedBox(height: AppSpacing.x3l),
                    LoginHeader(),
                    SizedBox(height: AppSpacing.xxl),
                    LoginFeedbackBanner(),
                    LoginEmailField(),
                    SizedBox(height: AppSpacing.lg),
                    LoginPasswordField(),
                    SizedBox(height: AppSpacing.xs),
                    LoginOptionsRow(),
                    SizedBox(height: AppSpacing.xl),
                    LoginSubmitButton(),
                    SizedBox(height: AppSpacing.xxl - 2),
                    LoginFooter(),
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
