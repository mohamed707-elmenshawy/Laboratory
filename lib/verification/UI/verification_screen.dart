import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/helpers/auth_redirect.dart';
import '../../core/localization/localization.dart';
import '../../core/networking/dio_factory.dart';
import '../../login/UI/widgets/login_brand_panel.dart';
import '../../login/UI/widgets/login_layout.dart';
import '../logic/verification_cubit.dart';
import 'widgets/verification_code_field.dart';
import 'widgets/verification_feedback_banner.dart';
import 'widgets/verification_footer.dart';
import 'widgets/verification_header.dart';
import 'widgets/verification_submit_button.dart';
import 'widgets/verification_top_bar.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  static Route<void> route({required String email}) => MaterialPageRoute<void>(
    builder: (_) => BlocProvider<VerificationCubit>(
      create: (_) => getIt<VerificationCubit>()..email = email,
      child: const VerificationScreen(),
    ),
  );

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with AuthRedirect {
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
    return BlocListener<VerificationCubit, VerificationState>(
      listenWhen: (VerificationState previous, VerificationState current) =>
          current is VerificationSuccess,
      listener: (BuildContext context, VerificationState state) {
        TextInput.finishAutofillContext();
        redirectToSignIn();
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
                    VerificationTopBar(),
                    SizedBox(height: AppSpacing.x3l),
                    VerificationHeader(),
                    SizedBox(height: AppSpacing.xxl),
                    VerificationFeedbackBanner(),
                    VerificationCodeField(),
                    SizedBox(height: AppSpacing.xl),
                    VerificationSubmitButton(),
                    SizedBox(height: AppSpacing.xxl - 2),
                    VerificationFooter(),
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
