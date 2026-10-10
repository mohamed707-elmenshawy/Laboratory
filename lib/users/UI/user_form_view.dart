import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../branches/data/models/branch_menu_item.dart';
import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/phones/phones.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../../laboratories/data/models/laboratory_menu_item.dart';
import '../data/models/role_model.dart';
import '../logic/user_details_cubit.dart';
import '../logic/user_form_cubit.dart';
import 'widgets/user_page_header.dart';
import 'widgets/user_permissions_field.dart';

class UserFormView extends StatelessWidget {
  const UserFormView({
    super.key,
    required this.onCancel,
    required this.onSaved,
    required this.onCreated,
    required this.isCreating,
  });

  static Widget page({
    required VoidCallback onCancel,
    required VoidCallback onSaved,
    required VoidCallback onCreated,
    int? id,
  }) => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<UserDetailsCubit>(
        create: (_) {
          final UserDetailsCubit cubit = getIt<UserDetailsCubit>();
          if (id != null) cubit.load(id);
          return cubit;
        },
      ),
      BlocProvider<UserFormCubit>(
        create: (_) {
          final UserFormCubit cubit = getIt<UserFormCubit>();
          if (id == null) cubit.startCreate();
          return cubit..loadCatalogue();
        },
      ),
    ],
    child: UserFormView(
      onCancel: onCancel,
      onSaved: onSaved,
      onCreated: onCreated,
      isCreating: id == null,
    ),
  );

  final VoidCallback onCancel;
  final VoidCallback onSaved;
  final VoidCallback onCreated;
  final bool isCreating;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<UserDetailsCubit, UserDetailsState>(
          listenWhen: (UserDetailsState previous, UserDetailsState next) =>
              next is UserDetailsLoaded,
          listener: (BuildContext context, UserDetailsState state) {
            context.read<UserFormCubit>().seed(
              (state as UserDetailsLoaded).user,
            );
          },
        ),
        BlocListener<UserFormCubit, UserFormState>(
          listenWhen: (UserFormState previous, UserFormState next) =>
              next is UserFormSaved || next is UserFormCreated,
          listener: (BuildContext context, UserFormState state) =>
              switch (state) {
                UserFormSaved() => onSaved(),
                _ => onCreated(),
              },
        ),
      ],
      child: HomePageFrame(
        maxWidth: AppSizes.pageFormMaxWidth,
        child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
          builder: (BuildContext context, UserDetailsState state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserPageHeader(
                title: isCreating ? s.createUserTitle : s.editUserTitle,
                subtitle: isCreating
                    ? s.createUserSubtitle
                    : s.editUserSubtitle,
                onBack: onCancel,
              ),
              const SizedBox(height: AppSpacing.x3l),
              if (isCreating)
                _Form(onCancel: onCancel, isCreating: true)
              else
                switch (state) {
                  UserDetailsLoaded() => _Form(onCancel: onCancel),
                  UserDetailsFailure(:final AppError error) => _Failed(
                    error: error,
                  ),
                  UserDetailsInitial() ||
                  UserDetailsLoading() => const _Loading(),
                },
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({required this.onCancel, this.isCreating = false});

  final VoidCallback onCancel;
  final bool isCreating;

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _AccountCard(isCreating: isCreating),
          const SizedBox(height: AppSpacing.xxl),
          const _AccessCard(),
          const SizedBox(height: AppSpacing.xxl),
          const _PhonesCard(),
          const SizedBox(height: AppSpacing.xxl),
          const _FailureBanner(),
          _Actions(onCancel: onCancel, isCreating: isCreating),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.isCreating});

  final bool isCreating;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _CardTitle(s.userAccountSection),
          const SizedBox(height: AppSpacing.lg),
          const _NameField(),
          const SizedBox(height: AppSpacing.lg),
          const _EmailField(),
          const SizedBox(height: AppSpacing.lg),
          _PasswordField(isCreating: isCreating),
          const SizedBox(height: AppSpacing.lg),
          _PasswordConfirmationField(isCreating: isCreating),
        ],
      ),
    );
  }
}

class _AccessCard extends StatelessWidget {
  const _AccessCard();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<UserFormCubit, UserFormState>(
      builder: (BuildContext context, UserFormState state) {
        final UserFormCubit cubit = context.read<UserFormCubit>();

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _CardTitle(s.userAccessSection),
              const SizedBox(height: AppSpacing.xs),
              Text(
                s.userRolesHint,
                style: DefaultTextStyle.of(context).style
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.inkSubtle),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _RolesField(),
              if (cubit.needsLaboratory) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                const _LaboratoryField(),
              ],
              if (cubit.needsBranch) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                const _BranchField(),
              ],
              if (cubit.needsCommission) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                const _CommissionField(),
              ],
              if (cubit.roles.isNotEmpty && !cubit.needsCommission) ...<Widget>[
                const SizedBox(height: AppSpacing.xxl),
                const Divider(height: 1, thickness: 1, color: AppColors.line),
                const SizedBox(height: AppSpacing.lg),
                UserPermissionsField(
                  serverError:
                      _serverError(state, 'permissions') ??
                      _serverError(state, 'permissions.0'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Text(
      label,
      style: base
          .merge(AppTextStyles.label)
          .copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UserFormCubit cubit = context.read<UserFormCubit>();
    final bool enabled = context.select((UserFormCubit cubit) => !cubit.isBusy);
    final String? serverError = context.select(
      (UserFormCubit cubit) => _serverError(cubit.state, 'name'),
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit.nameController.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.userNameLabel,
        controller: cubit.nameController,
        prefixIcon: Icons.person_outline_rounded,
        enabled: enabled,
        maxLength: 30,
        errorText: field.hasError
            ? _errorFor(cubit.nameController.text, s)
            : serverError,
        onChanged: (String value) {
          cubit.fieldEdited();
          field.didChange(value);
        },
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) {
    final String name = value.trim();

    if (name.isEmpty) return s.userNameRequired;
    if (name.length > 30) return s.userNameTooLong;
    return null;
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UserFormCubit cubit = context.read<UserFormCubit>();
    final bool enabled = context.select((UserFormCubit cubit) => !cubit.isBusy);
    final String? serverError = context.select(
      (UserFormCubit cubit) => _serverError(cubit.state, 'email'),
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit.emailController.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.userEmailLabel,
        controller: cubit.emailController,
        prefixIcon: Icons.alternate_email_rounded,
        enabled: enabled,
        keyboardType: TextInputType.emailAddress,
        textDirection: TextDirection.ltr,
        errorText: field.hasError
            ? _errorFor(cubit.emailController.text, s)
            : serverError,
        onChanged: (String value) {
          cubit.fieldEdited();
          field.didChange(value);
        },
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) {
    final String email = value.trim();

    if (email.isEmpty) return s.emailRequired;
    if (!email.contains('@') || !email.contains('.')) return s.emailInvalid;
    if (email.length > 100) return s.userEmailTooLong;
    return null;
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.isCreating});

  final bool isCreating;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UserFormCubit cubit = context.read<UserFormCubit>();
    final bool enabled = context.select((UserFormCubit cubit) => !cubit.isBusy);
    final String? serverError = context.select(
      (UserFormCubit cubit) => _serverError(cubit.state, 'password'),
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit.passwordController.text, s, isCreating),
      builder: (FormFieldState<String> field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppPasswordField(
            label: isCreating ? s.userPasswordLabel : s.userNewPasswordLabel,
            showPasswordLabel: s.showPassword,
            hidePasswordLabel: s.hidePassword,
            controller: cubit.passwordController,
            enabled: enabled,
            errorText: field.hasError
                ? _errorFor(cubit.passwordController.text, s, isCreating)
                : serverError,
            onChanged: (String value) {
              cubit.fieldEdited();
              field.didChange(value);
            },
          ),
          if (!isCreating) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Text(
              s.userPasswordKeepHint,
              style: DefaultTextStyle.of(context).style
                  .merge(AppTextStyles.caption)
                  .copyWith(color: AppColors.inkSubtle),
            ),
          ],
        ],
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s, bool isCreating) {
    if (value.isEmpty) return isCreating ? s.passwordRequired : null;
    if (value.length < 8) return s.userPasswordTooShort;
    return null;
  }
}

class _PasswordConfirmationField extends StatelessWidget {
  const _PasswordConfirmationField({required this.isCreating});

  final bool isCreating;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UserFormCubit cubit = context.read<UserFormCubit>();
    final bool enabled = context.select((UserFormCubit cubit) => !cubit.isBusy);
    final String? serverError = context.select(
      (UserFormCubit cubit) =>
          _serverError(cubit.state, 'password_confirmation'),
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit, s),
      builder: (FormFieldState<String> field) => AppPasswordField(
        label: s.passwordConfirmationLabel,
        hint: s.passwordConfirmationHint,
        showPasswordLabel: s.showPassword,
        hidePasswordLabel: s.hidePassword,
        controller: cubit.passwordConfirmationController,
        enabled: enabled,
        errorText: field.hasError ? _errorFor(cubit, s) : serverError,
        onChanged: (String value) {
          cubit.fieldEdited();
          field.didChange(value);
        },
      ),
    );
  }

  static String? _errorFor(UserFormCubit cubit, AppStrings s) {
    final String password = cubit.passwordController.text;
    final String confirmation = cubit.passwordConfirmationController.text;

    if (password.isEmpty && confirmation.isEmpty) return null;
    if (confirmation.isEmpty) return s.passwordConfirmationRequired;
    if (confirmation != password) return s.passwordMismatch;
    return null;
  }
}

class _RolesField extends StatelessWidget {
  const _RolesField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return BlocBuilder<UserFormCubit, UserFormState>(
      builder: (BuildContext context, UserFormState state) {
        final UserFormCubit cubit = context.read<UserFormCubit>();
        final List<RoleModel> catalogue = cubit.catalogue;
        final bool enabled = !cubit.isBusy;
        final String? serverError = _serverError(state, 'roles');

        if (catalogue.isEmpty) {
          return Text(
            s.userRolesUnavailable,
            style: base
                .merge(AppTextStyles.caption)
                .copyWith(color: AppColors.inkSubtle),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              s.userRolesLabel,
              style: base
                  .merge(AppTextStyles.label)
                  .copyWith(color: AppColors.inkSubtle),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                for (final RoleModel role in catalogue)
                  AppCheckbox(
                    value: cubit.roles.contains(role.name),
                    enabled: enabled,
                    label: s.roleLabel(role.name),
                    onChanged: (_) => cubit.toggleRole(role),
                  ),
              ],
            ),
            if (serverError != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                serverError,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.danger),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _LaboratoryField extends StatelessWidget {
  const _LaboratoryField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<UserFormCubit, UserFormState>(
      builder: (BuildContext context, UserFormState state) {
        final UserFormCubit cubit = context.read<UserFormCubit>();
        final List<LaboratoryMenuItem> laboratories = cubit.laboratories;
        final int? selected = cubit.laboratoryId;
        final bool known = laboratories.any(
          (LaboratoryMenuItem item) => item.id == selected,
        );

        return AppSelect<int>(
          label: s.branchLaboratoryLabel,
          value: known ? selected : null,
          enabled: state is! UserFormLoading && laboratories.isNotEmpty,
          errorText: _serverError(state, 'laboratory_id'),
          options: laboratories
              .map(
                (LaboratoryMenuItem item) =>
                    AppSelectOption<int>(value: item.id, label: item.name),
              )
              .toList(growable: false),
          onChanged: cubit.setLaboratory,
        );
      },
    );
  }
}

class _BranchField extends StatelessWidget {
  const _BranchField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return BlocBuilder<UserFormCubit, UserFormState>(
      builder: (BuildContext context, UserFormState state) {
        final UserFormCubit cubit = context.read<UserFormCubit>();
        final List<BranchMenuItem> branches = cubit.branches;
        final bool loading = cubit.branchesLoading;
        final int? selected = cubit.branchId;
        final bool known = branches.any(
          (BranchMenuItem branch) => branch.id == selected,
        );
        final bool empty =
            !loading && cubit.laboratoryId != null && branches.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppSelect<int>(
              label: s.userBranchLabel,
              value: known ? selected : null,
              enabled:
                  state is! UserFormLoading && !loading && branches.isNotEmpty,
              errorText: _serverError(state, 'branch_id'),
              options: branches
                  .map(
                    (BranchMenuItem branch) => AppSelectOption<int>(
                      value: branch.id,
                      label: branch.name,
                    ),
                  )
                  .toList(growable: false),
              onChanged: cubit.setBranch,
            ),
            if (empty) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                s.userBranchEmpty,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.danger),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _CommissionField extends StatelessWidget {
  const _CommissionField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UserFormCubit cubit = context.read<UserFormCubit>();
    final bool enabled = context.select((UserFormCubit cubit) => !cubit.isBusy);
    final String? serverError = context.select(
      (UserFormCubit cubit) =>
          _serverError(cubit.state, 'commission_percentage'),
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit.commissionController.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.userCommissionLabel,
        controller: cubit.commissionController,
        prefixIcon: Icons.percent_rounded,
        enabled: enabled,
        keyboardType: TextInputType.number,
        errorText: field.hasError
            ? _errorFor(cubit.commissionController.text, s)
            : serverError,
        onChanged: (String value) {
          cubit.fieldEdited();
          field.didChange(value);
        },
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) {
    final String raw = value.trim();
    if (raw.isEmpty) return s.userCommissionRequired;

    final double? parsed = double.tryParse(raw);
    if (parsed == null || parsed < 1 || parsed > 100) {
      return s.userCommissionRange;
    }
    return null;
  }
}

class _PhonesCard extends StatelessWidget {
  const _PhonesCard();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final UserFormCubit cubit = context.read<UserFormCubit>();

    return AppCard(
      child: ValueListenableBuilder<List<PhoneDraft>>(
        valueListenable: cubit.phones,
        builder: (BuildContext context, List<PhoneDraft> drafts, _) {
          return BlocBuilder<UserFormCubit, UserFormState>(
            builder: (BuildContext context, UserFormState state) {
              final bool enabled = state is! UserFormLoading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: _CardTitle(s.branchPhonesLabel)),
                      Text(
                        '${drafts.length} / ${UserFormCubit.maxPhones}',
                        style: base
                            .merge(AppTextStyles.caption)
                            .copyWith(color: AppColors.inkSubtle),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  for (int i = 0; i < drafts.length; i++) ...<Widget>[
                    if (i > 0) const SizedBox(height: AppSpacing.lg),
                    PhoneInputRow(
                      draft: drafts[i],
                      index: i,
                      phoneTypes: cubit.phoneTypes,
                      enabled: enabled,
                      onCountryChanged: (String country) =>
                          cubit.setPhoneCountry(drafts[i], country),
                      onTypeChanged: (String type) =>
                          cubit.setPhoneType(drafts[i], type),
                      onEdited: cubit.fieldEdited,
                      validator: () => _phoneError(cubit, drafts[i], s),
                      serverErrorFor: (String key) => _serverError(state, key),
                      onRemove: enabled
                          ? () => cubit.removePhone(drafts[i])
                          : null,
                      removeTooltip: s.removePhone,
                    ),
                  ],
                  if (drafts.isEmpty)
                    Text(
                      s.userNoPhones,
                      style: base
                          .merge(AppTextStyles.caption)
                          .copyWith(color: AppColors.inkSubtle),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: s.addPhone,
                    icon: Icons.add_rounded,
                    size: AppButtonSize.small,
                    variant: AppButtonVariant.secondary,
                    expand: false,
                    onPressed: enabled && cubit.canAddPhone
                        ? cubit.addPhone
                        : null,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  static String? _phoneError(
    UserFormCubit cubit,
    PhoneDraft draft,
    AppStrings s,
  ) {
    if (draft.isEmpty) return s.phoneRequired;
    if (cubit.duplicatePhone(draft) != null) return s.phoneDuplicate;
    return null;
  }
}

class _FailureBanner extends StatelessWidget {
  const _FailureBanner();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<UserFormCubit, UserFormState>(
      buildWhen: (UserFormState previous, UserFormState next) =>
          previous is UserFormFailure || next is UserFormFailure,
      builder: (BuildContext context, UserFormState state) {
        if (state is! UserFormFailure) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: AppAlert(
            feedback: state.error.toFeedback(s, title: s.feedbackSaveUserTitle),
            onDismiss: context.read<UserFormCubit>().dismissFailure,
            dismissTooltip: s.dismiss,
          ),
        );
      },
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.onCancel, required this.isCreating});

  final VoidCallback onCancel;
  final bool isCreating;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UserFormCubit cubit = context.read<UserFormCubit>();
    final bool busy = context.select((UserFormCubit cubit) => cubit.isBusy);
    final bool ready = context.select((UserFormCubit cubit) => cubit.isReady);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        AppButton(
          label: s.cancel,
          variant: AppButtonVariant.secondary,
          size: AppButtonSize.medium,
          onPressed: busy ? null : onCancel,
        ),
        const SizedBox(width: AppSpacing.md),
        AppButton(
          label: isCreating ? s.create : s.saveChanges,
          loadingLabel: isCreating ? s.creatingUser : s.savingChanges,
          size: AppButtonSize.medium,
          isLoading: busy,
          onPressed: busy || !ready
              ? null
              : () {
                  if (Form.of(context).validate()) cubit.save();
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
      title: s.feedbackUserDetailsTitle,
    );

    return AppAlert(
      feedback: AppFeedback(
        kind: feedback.kind,
        title: feedback.title,
        message: error.kind == AppErrorKind.notFound
            ? s.userGone
            : feedback.message,
        actionLabel: s.retry,
        onAction: () => context.read<UserDetailsCubit>().reload(),
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

String? _serverError(UserFormState state, String key) {
  if (state is! UserFormFailure) return null;

  final List<String>? messages = state.error.fieldErrors[key];
  if (messages == null || messages.isEmpty) return null;

  return messages.first;
}
