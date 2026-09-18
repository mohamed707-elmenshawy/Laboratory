import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/ui/ui.dart';
import '../../forgot_password/logic/forgot_password_cubit.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../logic/change_password_cubit.dart';
import 'widgets/change_password_confirmation_field.dart';
import 'widgets/change_password_current_field.dart';
import 'widgets/change_password_feedback_banner.dart';
import 'widgets/change_password_header.dart';
import 'widgets/change_password_new_field.dart';
import 'widgets/change_password_reset_link_card.dart';
import 'widgets/change_password_submit_button.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  static Widget page({required String email}) => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<ChangePasswordCubit>(
        create: (_) => getIt<ChangePasswordCubit>(),
      ),
      BlocProvider<ForgotPasswordCubit>(
        create: (_) =>
            getIt<ForgotPasswordCubit>()..emailController.text = email,
      ),
    ],
    child: const ChangePasswordView(),
  );

  @override
  Widget build(BuildContext context) {
    return const HomePageFrame(
      maxWidth: AppSizes.pageFormMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ChangePasswordHeader(),
          SizedBox(height: AppSpacing.x3l),
          AppCard(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteractionIfError,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ChangePasswordFeedbackBanner(),
                    ChangePasswordCurrentField(),
                    SizedBox(height: AppSpacing.lg),
                    ChangePasswordNewField(),
                    SizedBox(height: AppSpacing.lg),
                    ChangePasswordConfirmationField(),
                    SizedBox(height: AppSpacing.xl),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: ChangePasswordSubmitButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xxl),
          ChangePasswordResetLinkCard(),
        ],
      ),
    );
  }
}
