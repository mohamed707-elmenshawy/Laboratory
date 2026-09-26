import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../../home/logic/home_cubit.dart';
import '../data/models/phone_type_option.dart';
import '../data/models/profile_model.dart';
import '../logic/profile_cubit.dart';
import '../logic/update_profile_cubit.dart';
import 'widgets/profile_details_card.dart';
import 'widgets/profile_feedback_banner.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_phones_card.dart';
import 'widgets/profile_save_button.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  static Widget page() => BlocProvider<ProfileCubit>(
    create: (_) => getIt<ProfileCubit>()..loadProfile(),
    child: const ProfileView(),
  );

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  AppLocale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final AppLocale locale = context.appLocale;
    if (locale == _locale) return;

    final bool changed = _locale != null;
    _locale = locale;

    if (changed) context.read<ProfileCubit>().localeChanged();
  }

  @override
  Widget build(BuildContext context) {
    return HomePageFrame(
      maxWidth: AppSizes.pageFormMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ProfileHeader(),
          const SizedBox(height: AppSpacing.x3l),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (BuildContext context, ProfileState state) =>
                switch (state) {
                  ProfileLoaded(
                    :final ProfileModel profile,
                    :final List<PhoneTypeOption> phoneTypes,
                  ) =>
                    _Loaded(profile: profile, phoneTypes: phoneTypes),
                  ProfileFailure(:final AppError error) => _Failed(
                    error: error,
                  ),
                  ProfileInitial() || ProfileLoading() => const _Loading(),
                },
          ),
        ],
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.profile, required this.phoneTypes});

  final ProfileModel profile;
  final List<PhoneTypeOption> phoneTypes;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileCubit>(
      create: (_) => getIt<UpdateProfileCubit>()..seed(profile),
      child: BlocListener<UpdateProfileCubit, UpdateProfileState>(
        listenWhen: (UpdateProfileState previous, UpdateProfileState current) =>
            current is UpdateProfileSuccess,
        listener: (BuildContext context, UpdateProfileState state) {
          final ProfileModel updated = (state as UpdateProfileSuccess).profile;
          context.read<ProfileCubit>().profileUpdated(updated);
          context.read<HomeCubit>().userUpdated(updated.toUser());
        },
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProfileDetailsCard(profile: profile),
                const SizedBox(height: AppSpacing.xxl),
                ProfilePhonesCard(phoneTypes: phoneTypes),
                const SizedBox(height: AppSpacing.xxl),
                const ProfileFeedbackBanner(),
                const Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ProfileSaveButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.error});

  final AppError error;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final AppFeedback feedback = error.toFeedback(
      s,
      title: s.feedbackProfileLoadTitle,
    );

    return AppAlert(
      feedback: AppFeedback(
        kind: feedback.kind,
        title: feedback.title,
        message: feedback.message,
        actionLabel: s.retry,
        onAction: () => context.read<ProfileCubit>().loadProfile(),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.x5l),
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.brand600,
          ),
        ),
      ),
    );
  }
}
