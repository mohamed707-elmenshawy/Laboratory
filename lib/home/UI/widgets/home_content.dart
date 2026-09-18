import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/models/user_model.dart';
import '../../../core/ui/ui.dart';
import '../../logic/home_cubit.dart';
import 'home_access_card.dart';
import 'home_overview_empty.dart';
import 'home_page_frame.dart';
import 'home_welcome_header.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  static const double _twoColumnsFrom = 840;

  @override
  Widget build(BuildContext context) {
    return HomePageFrame(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (BuildContext context, HomeState state) => switch (state) {
          HomeLoaded(:final UserModel user) => _Loaded(user: user),
          HomeFailure(:final AppError error) => _Failed(error: error),
          HomeInitial() ||
          HomeLoading() ||
          HomeSessionExpired() => const _Loading(),
        },
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HomeWelcomeHeader(user: user),
        const SizedBox(height: AppSpacing.x3l),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < HomeContent._twoColumnsFrom) {
              return Column(
                children: <Widget>[
                  HomeAccessCard(user: user),
                  const SizedBox(height: AppSpacing.xxl),
                  const HomeOverviewEmpty(),
                ],
              );
            }

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(child: HomeAccessCard(user: user)),
                  const SizedBox(width: AppSpacing.xxl),
                  const Expanded(flex: 2, child: HomeOverviewEmpty()),
                ],
              ),
            );
          },
        ),
      ],
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
      title: s.feedbackHomeTitle,
    );

    return AppAlert(
      feedback: AppFeedback(
        kind: feedback.kind,
        title: feedback.title,
        message: feedback.message,
        actionLabel: s.retry,
        onAction: () => context.read<HomeCubit>().loadProfile(),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.x6l),
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
