import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../data/models/laboratory_model.dart';
import '../logic/laboratory_details_cubit.dart';
import '../logic/laboratory_status_cubit.dart';
import 'widgets/laboratory_details_card.dart';
import 'widgets/laboratory_form_header.dart';
import 'widgets/laboratory_status_pill.dart';

class LaboratoryDetailsView extends StatelessWidget {
  const LaboratoryDetailsView({
    super.key,
    required this.onBack,
    required this.onStatusChanged,
    required this.onEdit,
  });

  static Widget page({
    required int id,
    required VoidCallback onBack,
    required ValueChanged<LaboratoryModel> onStatusChanged,
    required ValueChanged<LaboratoryModel> onEdit,
  }) => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<LaboratoryDetailsCubit>(
        create: (_) => getIt<LaboratoryDetailsCubit>()..load(id),
      ),
      BlocProvider<LaboratoryStatusCubit>(
        create: (_) => getIt<LaboratoryStatusCubit>(),
      ),
    ],
    child: LaboratoryDetailsView(
      onBack: onBack,
      onStatusChanged: onStatusChanged,
      onEdit: onEdit,
    ),
  );

  final VoidCallback onBack;
  final ValueChanged<LaboratoryModel> onStatusChanged;
  final ValueChanged<LaboratoryModel> onEdit;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocListener<LaboratoryStatusCubit, LaboratoryStatusState>(
      listenWhen:
          (LaboratoryStatusState previous, LaboratoryStatusState next) =>
              next is LaboratoryStatusSuccess,
      listener: (BuildContext context, LaboratoryStatusState state) {
        final LaboratoryModel updated =
            (state as LaboratoryStatusSuccess).laboratory;
        context.read<LaboratoryDetailsCubit>().laboratoryUpdated(updated);
        onStatusChanged(updated);
      },
      child: HomePageFrame(
        maxWidth: AppSizes.pageFormMaxWidth,
        child: BlocBuilder<LaboratoryDetailsCubit, LaboratoryDetailsState>(
          builder: (BuildContext context, LaboratoryDetailsState state) {
            final LaboratoryModel? laboratory = switch (state) {
              LaboratoryDetailsLoaded(:final LaboratoryModel laboratory) =>
                laboratory,
              _ => null,
            };

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LaboratoryFormHeader(
                  title: laboratory?.name ?? s.laboratoryDetailsTitle,
                  subtitle: s.laboratoryDetailsSubtitle,
                  onBack: onBack,
                  leading: laboratory == null
                      ? null
                      : LaboratoryLogo(url: laboratory.logoUrl),
                  trailing: laboratory == null
                      ? null
                      : LaboratoryStatusPill(isActive: laboratory.isActive),
                ),
                const SizedBox(height: AppSpacing.x3l),
                switch (state) {
                  LaboratoryDetailsLoaded(:final LaboratoryModel laboratory) =>
                    LaboratoryDetailsCard(
                      laboratory: laboratory,
                      onEdit: () => onEdit(laboratory),
                    ),
                  LaboratoryDetailsFailure(:final AppError error) => _Failed(
                    error: error,
                  ),
                  LaboratoryDetailsInitial() ||
                  LaboratoryDetailsLoading() => const _Loading(),
                },
              ],
            );
          },
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
      title: s.feedbackLaboratoryDetailsTitle,
    );

    return AppAlert(
      feedback: AppFeedback(
        kind: feedback.kind,
        title: feedback.title,
        message: error.kind == AppErrorKind.notFound
            ? s.laboratoryGone
            : feedback.message,
        actionLabel: s.retry,
        onAction: () => context.read<LaboratoryDetailsCubit>().reload(),
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
