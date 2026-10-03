import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../../laboratories/data/models/laboratory_menu_item.dart';
import '../../laboratories/data/repos/laboratories_repo.dart';
import '../../core/error/result.dart';
import '../data/models/branch_model.dart';
import '../data/models/branches_page.dart';
import '../logic/branch_status_cubit.dart';
import '../logic/branches_cubit.dart';
import 'branch_details_view.dart';
import 'dialogs/branch_delete_dialog.dart';
import 'update_branch_view.dart';
import 'widgets/branches_header.dart';
import 'widgets/branches_pagination_bar.dart';
import 'widgets/branches_states.dart';
import 'widgets/branches_table.dart';
import 'widgets/branches_toolbar.dart';

class BranchesView extends StatefulWidget {
  const BranchesView({super.key});

  static Widget page() => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<BranchesCubit>(
        create: (_) => getIt<BranchesCubit>()..load(),
      ),
      BlocProvider<BranchStatusCubit>(
        create: (_) => getIt<BranchStatusCubit>(),
      ),
    ],
    child: const BranchesView(),
  );

  @override
  State<BranchesView> createState() => _BranchesViewState();
}

enum _Notice { created, updated, deleted, activated, deactivated }

class _BranchesViewState extends State<BranchesView> {
  int? _detailsId;
  int? _editingId;
  bool _creating = false;
  _Notice? _notice;
  AppError? _statusError;
  List<LaboratoryMenuItem> _laboratories = const <LaboratoryMenuItem>[];

  @override
  void initState() {
    super.initState();
    _loadLaboratories();
  }

  Future<void> _loadLaboratories() async {
    final Result<List<LaboratoryMenuItem>> result =
        await getIt<LaboratoriesRepo>().fetchLaboratoriesMenu();

    if (!mounted) return;
    if (result case Success<List<LaboratoryMenuItem>>(
      :final List<LaboratoryMenuItem> data,
    )) {
      setState(() => _laboratories = data);
    }
  }

  void _openCreate() => setState(() {
    _creating = true;
    _detailsId = null;
    _editingId = null;
    _notice = null;
  });

  void _closeCreate() => setState(() => _creating = false);

  void _onCreated() {
    setState(() {
      _creating = false;
      _notice = _Notice.created;
    });

    final BranchesCubit cubit = context.read<BranchesCubit>();
    if (cubit.page == 1) {
      cubit.load();
    } else {
      cubit.goToPage(1);
    }
  }

  void _openDetails(BranchModel branch) => setState(() {
    _detailsId = branch.id;
    _notice = null;
  });

  void _openEdit(BranchModel branch) => setState(() {
    _editingId = branch.id;
    _detailsId = null;
    _notice = null;
  });

  void _closeDetails() => setState(() => _detailsId = null);

  void _closeEdit() => setState(() => _editingId = null);

  void _onSaved(BranchModel branch) {
    setState(() {
      _editingId = null;
      _notice = _Notice.updated;
    });
    context.read<BranchesCubit>().branchUpdated(branch);
  }

  void _onToggleStatus(BranchModel branch) {
    setState(() {
      _notice = null;
      _statusError = null;
    });
    context.read<BranchStatusCubit>().toggle(branch);
  }

  void _onStatusChanged(BranchModel branch) {
    setState(() {
      _statusError = null;
      _notice = branch.isActive ? _Notice.activated : _Notice.deactivated;
    });
    context.read<BranchesCubit>().branchUpdated(branch);
  }

  Future<void> _onDelete(BranchModel branch) async {
    final bool deleted = await BranchDeleteDialog.show(context, branch);
    if (!deleted || !mounted) return;

    setState(() => _notice = _Notice.deleted);
    context.read<BranchesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    if (_creating) {
      return UpdateBranchView.page(
        onCancel: _closeCreate,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_editingId case final int id) {
      return UpdateBranchView.page(
        id: id,
        onCancel: _closeEdit,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_detailsId case final int id) {
      return BranchDetailsView.page(
        id: id,
        onBack: _closeDetails,
        onEdit: _openEdit,
      );
    }

    return BlocListener<BranchStatusCubit, BranchStatusState>(
      listenWhen: (BranchStatusState previous, BranchStatusState next) =>
          next is BranchStatusSuccess || next is BranchStatusFailure,
      listener: (BuildContext context, BranchStatusState state) =>
          switch (state) {
            BranchStatusSuccess(:final BranchModel branch) => _onStatusChanged(
              branch,
            ),
            BranchStatusFailure(:final AppError error) => setState(
              () => _statusError = error,
            ),
            _ => null,
          },
      child: HomePageFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BranchesHeader(
              onRefresh: () => context.read<BranchesCubit>().load(),
              onCreate: _openCreate,
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
              laboratories: _laboratories,
              onView: _openDetails,
              onEdit: _openEdit,
              onDelete: _onDelete,
              onToggleStatus: _onToggleStatus,
            ),
          ],
        ),
      ),
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
          title: s.branchCreatedTitle,
          message: s.branchCreatedMessage,
        ),
        _Notice.updated => AppFeedback.success(
          title: s.branchUpdatedTitle,
          message: s.branchUpdatedMessage,
        ),
        _Notice.deleted => AppFeedback.success(
          title: s.branchDeletedTitle,
          message: s.branchDeletedMessage,
        ),
        _Notice.activated => AppFeedback.success(
          title: s.branchActivatedTitle,
          message: s.branchActivatedMessage,
        ),
        _Notice.deactivated => AppFeedback.success(
          title: s.branchDeactivatedTitle,
          message: s.branchDeactivatedMessage,
        ),
      },
      onDismiss: onDismiss,
      dismissTooltip: s.dismiss,
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

    return AppAlert(
      feedback: error.toFeedback(s, title: s.feedbackBranchStatusTitle),
      onDismiss: onDismiss,
      dismissTooltip: s.dismiss,
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.laboratories,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final List<LaboratoryMenuItem> laboratories;
  final ValueChanged<BranchModel> onView;
  final ValueChanged<BranchModel> onEdit;
  final ValueChanged<BranchModel> onDelete;
  final ValueChanged<BranchModel> onToggleStatus;

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
          BranchesToolbar(laboratories: laboratories),
          BlocBuilder<BranchesCubit, BranchesState>(
            builder: (BuildContext context, BranchesState state) =>
                switch (state) {
                  BranchesLoaded(:final BranchesPage page) => _Loaded(
                    page: page,
                    onView: onView,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onToggleStatus: onToggleStatus,
                  ),
                  BranchesFailure(:final AppError error) =>
                    BranchesFailureState(error: error),
                  BranchesInitial() ||
                  BranchesLoading() => const BranchesLoadingState(),
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
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final BranchesPage page;
  final ValueChanged<BranchModel> onView;
  final ValueChanged<BranchModel> onEdit;
  final ValueChanged<BranchModel> onDelete;
  final ValueChanged<BranchModel> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (page.items.isEmpty)
          BranchesEmptyState(filtered: context.read<BranchesCubit>().hasFilters)
        else
          BranchesTable(
            branches: page.items,
            onView: onView,
            onEdit: onEdit,
            onDelete: onDelete,
            onToggleStatus: onToggleStatus,
            statusBusyId: context.select(
              (BranchStatusCubit cubit) => switch (cubit.state) {
                BranchStatusLoading(:final int id) => id,
                _ => null,
              },
            ),
          ),
        BranchesPaginationBar(pagination: page.pagination),
      ],
    );
  }
}
