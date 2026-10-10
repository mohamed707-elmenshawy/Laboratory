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
import '../data/models/user_model.dart';
import '../data/models/users_page.dart';
import '../logic/users_cubit.dart';
import 'dialogs/user_delete_dialog.dart';
import 'user_details_view.dart';
import 'user_form_view.dart';
import 'widgets/users_pagination_bar.dart';
import 'widgets/users_states.dart';
import 'widgets/users_table.dart';
import 'widgets/users_toolbar.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  static Widget page() => BlocProvider<UsersCubit>(
    create: (_) => getIt<UsersCubit>()..load(),
    child: const UsersView(),
  );

  @override
  State<UsersView> createState() => _UsersViewState();
}

enum _Notice { created, saved, deleted }

class _UsersViewState extends State<UsersView> {
  List<LaboratoryMenuItem> _laboratories = const <LaboratoryMenuItem>[];
  int? _detailsId;
  int? _editingId;
  bool _creating = false;
  _Notice? _notice;

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

  void _closeForm() => setState(() {
    _creating = false;
    _editingId = null;
  });

  void _openEdit(UserModel user) => setState(() {
    _editingId = user.id;
    _detailsId = null;
    _creating = false;
    _notice = null;
  });

  void _onCreated() {
    setState(() {
      _creating = false;
      _notice = _Notice.created;
    });

    final UsersCubit cubit = context.read<UsersCubit>();
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
    context.read<UsersCubit>().load();
  }

  void _openDetails(UserModel user) => setState(() {
    _detailsId = user.id;
    _notice = null;
  });

  void _closeDetails() => setState(() => _detailsId = null);

  Future<void> _onDelete(UserModel user) async {
    final bool deleted = await UserDeleteDialog.show(context, user);
    if (!deleted || !mounted) return;

    setState(() {
      _detailsId = null;
      _notice = _Notice.deleted;
    });
    context.read<UsersCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    if (_creating) {
      return UserFormView.page(
        onCancel: _closeForm,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_editingId case final int id) {
      return UserFormView.page(
        id: id,
        onCancel: _closeForm,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_detailsId case final int id) {
      return UserDetailsView.page(
        id: id,
        onBack: _closeDetails,
        onEdit: _openEdit,
        onDelete: _onDelete,
      );
    }

    return HomePageFrame(
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
                      s.usersTitle,
                      style: base
                          .merge(AppTextStyles.h2)
                          .copyWith(color: AppColors.ink),
                    ),
                    const SizedBox(height: AppSpacing.xs + 2),
                    Text(
                      s.usersSubtitle,
                      style: base
                          .merge(AppTextStyles.body)
                          .copyWith(color: AppColors.inkSubtle),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              AppButton(
                label: s.newUser,
                size: AppButtonSize.medium,
                icon: Icons.person_add_alt_1_outlined,
                onPressed: _openCreate,
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: () => context.read<UsersCubit>().load(),
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
                  title: s.userCreatedTitle,
                  message: s.userCreatedMessage,
                ),
                _Notice.saved => AppFeedback.success(
                  title: s.userSavedTitle,
                  message: s.userSavedMessage,
                ),
                _Notice.deleted => AppFeedback.success(
                  title: s.userDeletedTitle,
                  message: s.userDeletedMessage,
                ),
              },
              onDismiss: () => setState(() => _notice = null),
              dismissTooltip: s.dismiss,
            ),
          ],
          const SizedBox(height: AppSpacing.x3l),
          _ListCard(
            laboratories: _laboratories,
            onView: _openDetails,
            onEdit: _openEdit,
            onDelete: _onDelete,
          ),
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.laboratories,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final List<LaboratoryMenuItem> laboratories;
  final ValueChanged<UserModel> onView;
  final ValueChanged<UserModel> onEdit;
  final ValueChanged<UserModel> onDelete;

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
          UsersToolbar(laboratories: laboratories),
          BlocBuilder<UsersCubit, UsersState>(
            builder: (BuildContext context, UsersState state) =>
                switch (state) {
                  UsersLoaded(:final UsersPage page) => _Loaded(
                    page: page,
                    onView: onView,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                  UsersFailure(:final AppError error) => UsersFailureState(
                    error: error,
                  ),
                  UsersInitial() || UsersLoading() => const UsersLoadingState(),
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
  });

  final UsersPage page;
  final ValueChanged<UserModel> onView;
  final ValueChanged<UserModel> onEdit;
  final ValueChanged<UserModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (page.items.isEmpty)
          UsersEmptyState(filtered: context.read<UsersCubit>().hasFilters)
        else
          UsersTable(
            users: page.items,
            onView: onView,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        UsersPaginationBar(pagination: page.pagination),
      ],
    );
  }
}
