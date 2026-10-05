import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../../laboratories/data/models/laboratory_menu_item.dart';
import '../../laboratories/data/repos/laboratories_repo.dart';
import '../data/models/units_page.dart';
import '../data/models/unit_model.dart';
import '../logic/units_cubit.dart';
import '../logic/unit_status_cubit.dart';
import 'dialogs/unit_delete_dialog.dart';
import 'unit_details_view.dart';
import 'unit_form_view.dart';
import 'widgets/units_pagination_bar.dart';
import 'widgets/units_states.dart';
import 'widgets/units_table.dart';
import 'widgets/units_toolbar.dart';

class UnitsView extends StatefulWidget {
  const UnitsView({super.key});

  static Widget page() => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<UnitsCubit>(create: (_) => getIt<UnitsCubit>()..load()),
      BlocProvider<UnitStatusCubit>(create: (_) => getIt<UnitStatusCubit>()),
    ],
    child: const UnitsView(),
  );

  @override
  State<UnitsView> createState() => _UnitsViewState();
}

class _UnitsViewState extends State<UnitsView> {
  List<LaboratoryMenuItem> _laboratories = const <LaboratoryMenuItem>[];
  int? _detailsId;
  int? _editingId;
  bool _creating = false;
  _Notice? _notice;
  AppError? _statusError;

  void _openCreate() => setState(() {
    _creating = true;
    _detailsId = null;
    _editingId = null;
    _notice = null;
  });

  void _closeForm() => setState(() {
    _creating = false;
    _editingId = null;
  });

  void _openEdit(UnitModel unit) => setState(() {
    _editingId = unit.id;
    _detailsId = null;
    _creating = false;
    _notice = null;
  });

  void _onCreated() {
    setState(() {
      _creating = false;
      _notice = _Notice.created;
    });

    final UnitsCubit cubit = context.read<UnitsCubit>();
    if (cubit.page == 1) {
      cubit.load();
    } else {
      cubit.goToPage(1);
    }
  }

  void _onSaved() {
    setState(() {
      _editingId = null;
      _notice = _Notice.saved;
    });
    context.read<UnitsCubit>().load();
  }

  void _openDetails(UnitModel unit) => setState(() {
    _detailsId = unit.id;
    _notice = null;
  });

  void _closeDetails() => setState(() => _detailsId = null);

  void _onToggleStatus(UnitModel unit) {
    setState(() {
      _notice = null;
      _statusError = null;
    });
    context.read<UnitStatusCubit>().toggle(unit);
  }

  void _onStatusChanged(UnitModel unit) {
    setState(() {
      _statusError = null;
      _notice = unit.isActive ? _Notice.activated : _Notice.deactivated;
    });
    context.read<UnitsCubit>().unitUpdated(unit);
  }

  Future<void> _onDelete(UnitModel unit) async {
    final bool deleted = await UnitDeleteDialog.show(context, unit);
    if (!deleted || !mounted) return;

    setState(() {
      _detailsId = null;
      _notice = _Notice.deleted;
    });
    context.read<UnitsCubit>().load();
  }

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

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    if (_creating) {
      return UnitFormView.page(
        onCancel: _closeForm,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_editingId case final int id) {
      return UnitFormView.page(
        id: id,
        onCancel: _closeForm,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_detailsId case final int id) {
      return UnitDetailsView.page(
        id: id,
        onBack: _closeDetails,
        onEdit: _openEdit,
        onDelete: _onDelete,
      );
    }

    return BlocListener<UnitStatusCubit, UnitStatusState>(
      listenWhen: (UnitStatusState previous, UnitStatusState next) =>
          next is UnitStatusSuccess || next is UnitStatusFailure,
      listener: (BuildContext context, UnitStatusState state) =>
          switch (state) {
            UnitStatusSuccess(:final UnitModel unit) => _onStatusChanged(unit),
            UnitStatusFailure(:final AppError error) => setState(
              () => _statusError = error,
            ),
            _ => null,
          },
      child: HomePageFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        s.unitsTitle,
                        style: base
                            .merge(AppTextStyles.h2)
                            .copyWith(color: AppColors.ink),
                      ),
                      const SizedBox(height: AppSpacing.xs + 2),
                      Text(
                        s.unitsSubtitle,
                        style: base
                            .merge(AppTextStyles.body)
                            .copyWith(color: AppColors.inkSubtle),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                AppButton(
                  label: s.newUnit,
                  size: AppButtonSize.medium,
                  icon: Icons.add_rounded,
                  onPressed: _openCreate,
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: () => context.read<UnitsCubit>().load(),
                  tooltip: s.refresh,
                  iconSize: AppSizes.iconMd,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: AppSizes.hitTarget,
                    height: AppSizes.hitTarget,
                  ),
                  hoverColor: AppColors.brandWash,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
            if (_notice case final _Notice notice) ...<Widget>[
              const SizedBox(height: AppSpacing.xl),
              AppAlert(
                feedback: switch (notice) {
                  _Notice.created => AppFeedback.success(
                    title: s.unitCreatedTitle,
                    message: s.unitCreatedMessage,
                  ),
                  _Notice.saved => AppFeedback.success(
                    title: s.unitSavedTitle,
                    message: s.unitSavedMessage,
                  ),
                  _Notice.deleted => AppFeedback.success(
                    title: s.unitDeletedTitle,
                    message: s.unitDeletedMessage,
                  ),
                  _Notice.activated => AppFeedback.success(
                    title: s.unitActivatedTitle,
                    message: s.unitActivatedMessage,
                  ),
                  _Notice.deactivated => AppFeedback.success(
                    title: s.unitDeactivatedTitle,
                    message: s.unitDeactivatedMessage,
                  ),
                },
                onDismiss: () => setState(() => _notice = null),
                dismissTooltip: s.dismiss,
              ),
            ],
            if (_statusError case final AppError error) ...<Widget>[
              const SizedBox(height: AppSpacing.xl),
              AppAlert(
                feedback: error.toFeedback(s, title: s.feedbackUnitStatusTitle),
                onDismiss: () => setState(() => _statusError = null),
                dismissTooltip: s.dismiss,
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

enum _Notice { created, saved, deleted, activated, deactivated }

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.laboratories,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final List<LaboratoryMenuItem> laboratories;
  final ValueChanged<UnitModel> onView;
  final ValueChanged<UnitModel> onEdit;
  final ValueChanged<UnitModel> onDelete;
  final ValueChanged<UnitModel> onToggleStatus;

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
          UnitsToolbar(laboratories: laboratories),
          BlocBuilder<UnitsCubit, UnitsState>(
            builder: (BuildContext context, UnitsState state) =>
                switch (state) {
                  UnitsLoaded(:final UnitsPage page) => _Loaded(
                    page: page,
                    onView: onView,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onToggleStatus: onToggleStatus,
                  ),
                  UnitsFailure(:final AppError error) => UnitsFailureState(
                    error: error,
                  ),
                  UnitsInitial() || UnitsLoading() => const UnitsLoadingState(),
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

  final UnitsPage page;
  final ValueChanged<UnitModel> onView;
  final ValueChanged<UnitModel> onEdit;
  final ValueChanged<UnitModel> onDelete;
  final ValueChanged<UnitModel> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (page.items.isEmpty)
          UnitsEmptyState(filtered: context.read<UnitsCubit>().hasFilters)
        else
          UnitsTable(
            units: page.items,
            onView: onView,
            onEdit: onEdit,
            onDelete: onDelete,
            onToggleStatus: onToggleStatus,
            statusBusyId: context.select(
              (UnitStatusCubit cubit) => switch (cubit.state) {
                UnitStatusLoading(:final int id) => id,
                _ => null,
              },
            ),
          ),
        UnitsPaginationBar(pagination: page.pagination),
      ],
    );
  }
}
