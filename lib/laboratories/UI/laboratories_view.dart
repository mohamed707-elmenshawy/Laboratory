import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../data/models/laboratories_page.dart';
import '../data/models/laboratory_model.dart';
import '../logic/laboratories_cubit.dart';
import '../logic/laboratory_status_cubit.dart';
import 'create_laboratory_view.dart';
import 'dialogs/laboratory_delete_dialog.dart';
import 'dialogs/laboratory_form_dialog.dart';
import 'laboratory_details_view.dart';
import 'widgets/laboratories_header.dart';
import 'widgets/laboratories_pagination_bar.dart';
import 'widgets/laboratories_states.dart';
import 'widgets/laboratories_table.dart';
import 'widgets/laboratories_toolbar.dart';

class LaboratoriesView extends StatefulWidget {
  const LaboratoriesView({super.key});

  static Widget page() => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<LaboratoriesCubit>(
        create: (_) => getIt<LaboratoriesCubit>()..load(),
      ),
      BlocProvider<LaboratoryStatusCubit>(
        create: (_) => getIt<LaboratoryStatusCubit>(),
      ),
    ],
    child: const LaboratoriesView(),
  );

  @override
  State<LaboratoriesView> createState() => _LaboratoriesViewState();
}

enum _Notice { created, deleted, activated, deactivated }

class _LaboratoriesViewState extends State<LaboratoriesView> {
  bool _creating = false;
  int? _detailsId;
  _Notice? _notice;
  AppError? _statusError;

  void _openCreate() => setState(() {
    _creating = true;
    _notice = null;
  });

  void _closeCreate() => setState(() => _creating = false);

  void _openDetails(LaboratoryModel laboratory) => setState(() {
    _detailsId = laboratory.id;
    _notice = null;
  });

  void _closeDetails() {
    setState(() => _detailsId = null);
    context.read<LaboratoriesCubit>().load();
  }

  void _onToggleStatus(LaboratoryModel laboratory) {
    setState(() {
      _notice = null;
      _statusError = null;
    });
    context.read<LaboratoryStatusCubit>().toggle(laboratory);
  }

  void _onStatusFailed(AppError error) => setState(() => _statusError = error);

  void _onStatusChanged(LaboratoryModel laboratory) {
    setState(() {
      _statusError = null;
      _notice = laboratory.isActive ? _Notice.activated : _Notice.deactivated;
    });
    context.read<LaboratoriesCubit>().laboratoryUpdated(laboratory);
  }

  void _onCreated() {
    setState(() {
      _creating = false;
      _notice = _Notice.created;
    });

    final LaboratoriesCubit cubit = context.read<LaboratoriesCubit>();
    if (cubit.page == 1) {
      cubit.load();
    } else {
      cubit.goToPage(1);
    }
  }

  Future<void> _onDelete(LaboratoryModel laboratory) async {
    final bool deleted = await LaboratoryDeleteDialog.show(context, laboratory);
    if (!deleted || !mounted) return;

    setState(() => _notice = _Notice.deleted);
    context.read<LaboratoriesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    if (_detailsId case final int id) {
      return LaboratoryDetailsView.page(
        id: id,
        onBack: _closeDetails,
        onStatusChanged: _onStatusChanged,
      );
    }

    if (_creating) {
      return CreateLaboratoryView.page(
        lang: context.appLocale,
        onCancel: _closeCreate,
        onCreated: _onCreated,
      );
    }

    return BlocListener<LaboratoryStatusCubit, LaboratoryStatusState>(
      listenWhen:
          (LaboratoryStatusState previous, LaboratoryStatusState next) =>
              next is LaboratoryStatusSuccess ||
              next is LaboratoryStatusFailure,
      listener: (BuildContext context, LaboratoryStatusState state) =>
          switch (state) {
            LaboratoryStatusSuccess(:final LaboratoryModel laboratory) =>
              _onStatusChanged(laboratory),
            LaboratoryStatusFailure(:final AppError error) => _onStatusFailed(
              error,
            ),
            _ => null,
          },
      child: HomePageFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LaboratoriesHeader(
              onCreate: _openCreate,
              onRefresh: () => context.read<LaboratoriesCubit>().load(),
            ),
            if (_notice case final _Notice notice) ...<Widget>[
              const SizedBox(height: AppSpacing.xl),
              _NoticeBanner(
                notice: notice,
                onDismiss: () => setState(() => _notice = null),
              ),
            ],
            if (_statusError case final AppError error) ...<Widget>[
              const SizedBox(height: AppSpacing.xl),
              _StatusErrorBanner(
                error: error,
                onDismiss: () => setState(() => _statusError = null),
              ),
            ],
            const SizedBox(height: AppSpacing.x3l),
            _ListCard(
              onView: _openDetails,
              onDelete: _onDelete,
              onToggleStatus: _onToggleStatus,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusErrorBanner extends StatelessWidget {
  const _StatusErrorBanner({required this.error, required this.onDismiss});

  final AppError error;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final AppFeedback feedback = error.toFeedback(
      s,
      title: s.feedbackLaboratoryStatusTitle,
    );

    return AppAlert(
      feedback: AppFeedback(
        kind: feedback.kind,
        title: feedback.title,
        message: error.kind == AppErrorKind.notFound
            ? s.laboratoryGone
            : feedback.message,
      ),
      onDismiss: onDismiss,
      dismissTooltip: s.dismiss,
    );
  }
}

class _NoticeBanner extends StatelessWidget {
  const _NoticeBanner({required this.notice, required this.onDismiss});

  final _Notice notice;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return AppAlert(
      feedback: switch (notice) {
        _Notice.created => AppFeedback.success(
          title: s.laboratoryCreatedTitle,
          message: s.laboratoryCreatedMessage,
        ),
        _Notice.deleted => AppFeedback.success(
          title: s.laboratoryDeletedTitle,
          message: s.laboratoryDeletedMessage,
        ),
        _Notice.activated => AppFeedback.success(
          title: s.laboratoryActivatedTitle,
          message: s.laboratoryActivatedMessage,
        ),
        _Notice.deactivated => AppFeedback.success(
          title: s.laboratoryDeactivatedTitle,
          message: s.laboratoryDeactivatedMessage,
        ),
      },
      onDismiss: onDismiss,
      dismissTooltip: s.dismiss,
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.onView,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final ValueChanged<LaboratoryModel> onView;
  final ValueChanged<LaboratoryModel> onDelete;
  final ValueChanged<LaboratoryModel> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.line, width: AppSizes.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const LaboratoriesToolbar(),
          BlocBuilder<LaboratoriesCubit, LaboratoriesState>(
            builder: (BuildContext context, LaboratoriesState state) =>
                switch (state) {
                  LaboratoriesLoaded(:final LaboratoriesPage page) => _Loaded(
                    page: page,
                    onView: onView,
                    onDelete: onDelete,
                    onToggleStatus: onToggleStatus,
                  ),
                  LaboratoriesFailure(:final AppError error) =>
                    LaboratoriesFailureState(error: error),
                  LaboratoriesInitial() ||
                  LaboratoriesLoading() => const LaboratoriesLoadingState(),
                },
          ),
        ],
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({
    required this.page,
    required this.onView,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final LaboratoriesPage page;
  final ValueChanged<LaboratoryModel> onView;
  final ValueChanged<LaboratoryModel> onDelete;
  final ValueChanged<LaboratoryModel> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (page.items.isEmpty)
          LaboratoriesEmptyState(
            filtered: context.read<LaboratoriesCubit>().hasFilters,
          )
        else
          LaboratoriesTable(
            laboratories: page.items,
            onView: onView,
            onEdit: (LaboratoryModel laboratory) =>
                LaboratoryFormDialog.show(context, laboratory: laboratory),
            onDelete: onDelete,
            onToggleStatus: onToggleStatus,
            statusBusyId: context.select(
              (LaboratoryStatusCubit cubit) => switch (cubit.state) {
                LaboratoryStatusLoading(:final int id) => id,
                _ => null,
              },
            ),
          ),
        LaboratoriesPaginationBar(pagination: page.pagination),
      ],
    );
  }
}
