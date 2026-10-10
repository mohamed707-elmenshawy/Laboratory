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
import '../data/models/parameters_page.dart';
import '../data/models/parameter_model.dart';
import '../logic/parameters_cubit.dart';
import '../logic/parameter_status_cubit.dart';
import 'dialogs/parameter_delete_dialog.dart';
import 'parameter_details_view.dart';
import 'parameter_form_view.dart';
import 'widgets/parameters_pagination_bar.dart';
import 'widgets/parameters_states.dart';
import 'widgets/parameters_table.dart';
import 'widgets/parameters_toolbar.dart';

class ParametersView extends StatefulWidget {
  const ParametersView({super.key});

  static Widget page() => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<ParametersCubit>(
        create: (_) => getIt<ParametersCubit>()..load(),
      ),
      BlocProvider<ParameterStatusCubit>(
        create: (_) => getIt<ParameterStatusCubit>(),
      ),
    ],
    child: const ParametersView(),
  );

  @override
  State<ParametersView> createState() => _ParametersViewState();
}

class _ParametersViewState extends State<ParametersView> {
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

  void _openEdit(ParameterModel parameter) => setState(() {
    _editingId = parameter.id;
    _detailsId = null;
    _creating = false;
    _notice = null;
  });

  void _onCreated() {
    setState(() {
      _creating = false;
      _notice = _Notice.created;
    });

    final ParametersCubit cubit = context.read<ParametersCubit>();
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
    context.read<ParametersCubit>().load();
  }

  void _openDetails(ParameterModel parameter) => setState(() {
    _detailsId = parameter.id;
    _notice = null;
  });

  void _closeDetails() => setState(() => _detailsId = null);

  void _onToggleStatus(ParameterModel parameter) {
    setState(() {
      _notice = null;
      _statusError = null;
    });
    context.read<ParameterStatusCubit>().toggle(parameter);
  }

  void _onStatusChanged(ParameterModel parameter) {
    setState(() {
      _statusError = null;
      _notice = parameter.isActive ? _Notice.activated : _Notice.deactivated;
    });
    context.read<ParametersCubit>().parameterUpdated(parameter);
  }

  Future<void> _onDelete(ParameterModel parameter) async {
    final bool deleted = await ParameterDeleteDialog.show(context, parameter);
    if (!deleted || !mounted) return;

    setState(() {
      _detailsId = null;
      _notice = _Notice.deleted;
    });
    context.read<ParametersCubit>().load();
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
      return ParameterFormView.page(
        onCancel: _closeForm,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_editingId case final int id) {
      return ParameterFormView.page(
        id: id,
        onCancel: _closeForm,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_detailsId case final int id) {
      return ParameterDetailsView.page(
        id: id,
        onBack: _closeDetails,
        onEdit: _openEdit,
        onDelete: _onDelete,
      );
    }

    return BlocListener<ParameterStatusCubit, ParameterStatusState>(
      listenWhen: (ParameterStatusState previous, ParameterStatusState next) =>
          next is ParameterStatusSuccess || next is ParameterStatusFailure,
      listener: (BuildContext context, ParameterStatusState state) =>
          switch (state) {
            ParameterStatusSuccess(:final ParameterModel parameter) =>
              _onStatusChanged(parameter),
            ParameterStatusFailure(:final AppError error) => setState(
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
                        s.parametersTitle,
                        style: base
                            .merge(AppTextStyles.h2)
                            .copyWith(color: AppColors.ink),
                      ),
                      const SizedBox(height: AppSpacing.xs + 2),
                      Text(
                        s.parametersSubtitle,
                        style: base
                            .merge(AppTextStyles.body)
                            .copyWith(color: AppColors.inkSubtle),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                AppButton(
                  label: s.newParameter,
                  size: AppButtonSize.medium,
                  icon: Icons.add_rounded,
                  onPressed: _openCreate,
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: () => context.read<ParametersCubit>().load(),
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
                    title: s.parameterCreatedTitle,
                    message: s.parameterCreatedMessage,
                  ),
                  _Notice.saved => AppFeedback.success(
                    title: s.parameterSavedTitle,
                    message: s.parameterSavedMessage,
                  ),
                  _Notice.deleted => AppFeedback.success(
                    title: s.parameterDeletedTitle,
                    message: s.parameterDeletedMessage,
                  ),
                  _Notice.activated => AppFeedback.success(
                    title: s.parameterActivatedTitle,
                    message: s.parameterActivatedMessage,
                  ),
                  _Notice.deactivated => AppFeedback.success(
                    title: s.parameterDeactivatedTitle,
                    message: s.parameterDeactivatedMessage,
                  ),
                },
                onDismiss: () => setState(() => _notice = null),
                dismissTooltip: s.dismiss,
              ),
            ],
            if (_statusError case final AppError error) ...<Widget>[
              const SizedBox(height: AppSpacing.xl),
              AppAlert(
                feedback: error.toFeedback(
                  s,
                  title: s.feedbackParameterStatusTitle,
                ),
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
  final ValueChanged<ParameterModel> onView;
  final ValueChanged<ParameterModel> onEdit;
  final ValueChanged<ParameterModel> onDelete;
  final ValueChanged<ParameterModel> onToggleStatus;

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
          ParametersToolbar(laboratories: laboratories),
          BlocBuilder<ParametersCubit, ParametersState>(
            builder: (BuildContext context, ParametersState state) =>
                switch (state) {
                  ParametersLoaded(:final ParametersPage page) => _Loaded(
                    page: page,
                    onView: onView,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onToggleStatus: onToggleStatus,
                  ),
                  ParametersFailure(:final AppError error) =>
                    ParametersFailureState(error: error),
                  ParametersInitial() ||
                  ParametersLoading() => const ParametersLoadingState(),
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

  final ParametersPage page;
  final ValueChanged<ParameterModel> onView;
  final ValueChanged<ParameterModel> onEdit;
  final ValueChanged<ParameterModel> onDelete;
  final ValueChanged<ParameterModel> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (page.items.isEmpty)
          ParametersEmptyState(
            filtered: context.read<ParametersCubit>().hasFilters,
          )
        else
          ParametersTable(
            parameters: page.items,
            onView: onView,
            onEdit: onEdit,
            onDelete: onDelete,
            onToggleStatus: onToggleStatus,
            statusBusyId: context.select(
              (ParameterStatusCubit cubit) => switch (cubit.state) {
                ParameterStatusLoading(:final int id) => id,
                _ => null,
              },
            ),
          ),
        ParametersPaginationBar(pagination: page.pagination),
      ],
    );
  }
}
