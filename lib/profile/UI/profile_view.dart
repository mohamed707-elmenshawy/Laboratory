import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../../home/logic/home_cubit.dart';
import '../data/models/profile_model.dart';
import '../logic/profile_cubit.dart';
import '../logic/update_profile_cubit.dart';
import 'widgets/profile_details_card.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_phones_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static Widget page() => BlocProvider<ProfileCubit>(
    create: (_) => getIt<ProfileCubit>()..loadProfile(),
    child: const ProfileView(),
  );

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
                  ProfileLoaded(:final ProfileModel profile) => _Loaded(
                    profile: profile,
                  ),
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
  const _Loaded({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileCubit>(
      create: (_) =>
          getIt<UpdateProfileCubit>()..nameController.text = profile.name,
      child: BlocListener<UpdateProfileCubit, UpdateProfileState>(
        listenWhen: (UpdateProfileState previous, UpdateProfileState current) =>
            current is UpdateProfileSuccess,
        listener: (BuildContext context, UpdateProfileState state) {
          final ProfileModel updated = (state as UpdateProfileSuccess).profile;
          context.read<ProfileCubit>().profileUpdated(updated);
          context.read<HomeCubit>().userUpdated(updated.toUser());
        },
        child: Column(
          children: <Widget>[
            ProfileDetailsCard(profile: profile),
            const SizedBox(height: AppSpacing.xxl),
            ProfilePhonesCard(phones: profile.phones),
          ],
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
