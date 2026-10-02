import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';

import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../../laboratories/data/models/laboratory_menu_item.dart';
import '../data/models/branch_model.dart';
import '../logic/branch_details_cubit.dart';
import '../logic/update_branch_cubit.dart';
import 'widgets/branch_page_header.dart';
import 'widgets/branch_phones_card.dart';

class UpdateBranchView extends StatelessWidget {
  const UpdateBranchView({
    super.key,
    required this.onCancel,
    required this.onSaved,
    required this.onCreated,
    this.isCreating = false,
  });

  static Widget page({
    required VoidCallback onCancel,
    required ValueChanged<BranchModel> onSaved,
    required VoidCallback onCreated,
    int? id,
  }) => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<BranchDetailsCubit>(
        create: (_) {
          final BranchDetailsCubit cubit = getIt<BranchDetailsCubit>();
          if (id != null) cubit.load(id);
          return cubit;
        },
      ),
      BlocProvider<UpdateBranchCubit>(
        create: (_) => getIt<UpdateBranchCubit>()..loadLaboratories(),
      ),
    ],
    child: UpdateBranchView(
      onCancel: onCancel,
      onSaved: onSaved,
      onCreated: onCreated,
      isCreating: id == null,
    ),
  );

  final VoidCallback onCancel;
  final ValueChanged<BranchModel> onSaved;
  final VoidCallback onCreated;
  final bool isCreating;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<BranchDetailsCubit, BranchDetailsState>(
          listenWhen: (BranchDetailsState previous, BranchDetailsState next) =>
              next is BranchDetailsLoaded,
          listener: (BuildContext context, BranchDetailsState state) {
            final BranchModel branch = (state as BranchDetailsLoaded).branch;
            context.read<UpdateBranchCubit>().seed(branch, context.appLocale);
          },
        ),
        BlocListener<UpdateBranchCubit, UpdateBranchState>(
          listenWhen: (UpdateBranchState previous, UpdateBranchState next) =>
              next is UpdateBranchSuccess || next is UpdateBranchCreated,
          listener: (BuildContext context, UpdateBranchState state) =>
              switch (state) {
                UpdateBranchSuccess(:final BranchModel branch) => onSaved(
                  branch,
                ),
                _ => onCreated(),
              },
        ),
      ],
      child: HomePageFrame(
        maxWidth: AppSizes.pageFormMaxWidth,
        child: BlocBuilder<BranchDetailsCubit, BranchDetailsState>(
          builder: (BuildContext context, BranchDetailsState state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BranchPageHeader(
                title: isCreating ? s.createBranchTitle : s.editBranchTitle,
                subtitle: isCreating
                    ? s.createBranchSubtitle
                    : s.editBranchSubtitle,
                onBack: onCancel,
              ),
              const SizedBox(height: AppSpacing.x3l),
              if (isCreating)
                _Form(onCancel: onCancel, isCreating: true)
              else
                switch (state) {
                  BranchDetailsLoaded() => _Form(onCancel: onCancel),
                  BranchDetailsFailure(:final AppError error) => _Failed(
                    error: error,
                  ),
                  BranchDetailsInitial() ||
                  BranchDetailsLoading() => const _Loading(),
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
          const _DetailsCard(),
          const SizedBox(height: AppSpacing.xxl),
          const BranchPhonesCard(),
          const SizedBox(height: AppSpacing.xxl),
          const _FailureBanner(),
          _Actions(onCancel: onCancel, isCreating: isCreating),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            s.branchDetailsTitle,
            style: base
                .merge(AppTextStyles.label)
                .copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _NameField(),
          const SizedBox(height: AppSpacing.lg),
          const _LaboratoryField(),
          const SizedBox(height: AppSpacing.lg),
          const _AddressField(),
          const SizedBox(height: AppSpacing.lg),
          const _LangField(),
          const SizedBox(height: AppSpacing.lg),
          const _MainBranchField(),
        ],
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UpdateBranchCubit cubit = context.read<UpdateBranchCubit>();
    final bool enabled = context.select(
      (UpdateBranchCubit cubit) => !cubit.isBusy,
    );
    final String? serverError = context.select(
      (UpdateBranchCubit cubit) => _serverError(cubit.state, 'name'),
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit.nameController.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.branchNameLabel,
        hint: s.branchNameHint,
        controller: cubit.nameController,
        prefixIcon: Icons.store_mall_directory_outlined,
        enabled: enabled,
        maxLength: 150,
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

    if (name.isEmpty) return s.branchNameRequired;
    if (name.length > 150) return s.branchNameTooLong;
    return null;
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UpdateBranchCubit cubit = context.read<UpdateBranchCubit>();
    final bool enabled = context.select(
      (UpdateBranchCubit cubit) => !cubit.isBusy,
    );
    final String? serverError = context.select(
      (UpdateBranchCubit cubit) => _serverError(cubit.state, 'address'),
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit.addressController.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.branchAddressLabel,
        hint: s.branchAddressHint,
        controller: cubit.addressController,
        prefixIcon: Icons.place_outlined,
        enabled: enabled,
        maxLength: 500,
        errorText: field.hasError
            ? _errorFor(cubit.addressController.text, s)
            : serverError,
        onChanged: (String value) {
          cubit.fieldEdited();
          field.didChange(value);
        },
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) =>
      value.trim().length > 500 ? s.branchAddressTooLong : null;
}

class _LaboratoryField extends StatelessWidget {
  const _LaboratoryField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<UpdateBranchCubit, UpdateBranchState>(
      builder: (BuildContext context, UpdateBranchState state) {
        final UpdateBranchCubit cubit = context.read<UpdateBranchCubit>();
        final List<LaboratoryMenuItem> laboratories = cubit.laboratories;
        final int? selected = cubit.laboratoryId;
        final bool known = laboratories.any(
          (LaboratoryMenuItem item) => item.id == selected,
        );

        return AppSelect<int>(
          label: s.branchLaboratoryLabel,
          value: known ? selected : null,
          enabled: state is! UpdateBranchLoading && laboratories.isNotEmpty,
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

class _LangField extends StatelessWidget {
  const _LangField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final UpdateBranchCubit cubit = context.read<UpdateBranchCubit>();
    final bool enabled = context.select(
      (UpdateBranchCubit cubit) => !cubit.isBusy,
    );
    final AppLocale lang = context.select(
      (UpdateBranchCubit cubit) => cubit.lang,
    );
    final List<AppLocale> locales = context.labSettings.availableLocales;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppSelect<AppLocale>(
          label: s.nameLanguageLabel,
          value: locales.contains(lang) ? lang : locales.first,
          enabled: enabled,
          errorText: _serverError(cubit.state, 'lang'),
          options: locales
              .map(
                (AppLocale locale) => AppSelectOption<AppLocale>(
                  value: locale,
                  label: locale.nativeName,
                ),
              )
              .toList(growable: false),
          onChanged: cubit.setLang,
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        Text(
          s.nameLanguageHint,
          style: base
              .merge(AppTextStyles.caption)
              .copyWith(color: AppColors.inkSubtle),
        ),
      ],
    );
  }
}

class _MainBranchField extends StatelessWidget {
  const _MainBranchField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UpdateBranchCubit cubit = context.read<UpdateBranchCubit>();
    final bool enabled = context.select(
      (UpdateBranchCubit cubit) => !cubit.isBusy,
    );
    final bool value = context.select(
      (UpdateBranchCubit cubit) => cubit.isMainBranch,
    );

    return AppCheckbox(
      value: value,
      label: s.branchMainLabel,
      semanticHint: s.branchMainHint,
      enabled: enabled,
      onChanged: cubit.setMainBranch,
    );
  }
}

class _FailureBanner extends StatelessWidget {
  const _FailureBanner();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<UpdateBranchCubit, UpdateBranchState>(
      builder: (BuildContext context, UpdateBranchState state) {
        if (state is! UpdateBranchFailure) {
          return const SizedBox(width: double.infinity);
        }

        final AppError error = state.error;
        final AppFeedback feedback = error.toFeedback(
          s,
          title: s.feedbackUpdateBranchTitle,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppAlert(
              feedback: AppFeedback(
                kind: feedback.kind,
                title: feedback.title,
                message: error.hasFieldErrors
                    ? error.fieldErrors.values.first.first
                    : feedback.message,
              ),
              onDismiss: () =>
                  context.read<UpdateBranchCubit>().dismissFailure(),
              dismissTooltip: s.dismiss,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
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
    final UpdateBranchCubit cubit = context.read<UpdateBranchCubit>();
    final bool busy = context.select((UpdateBranchCubit cubit) => cubit.isBusy);
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
          loadingLabel: isCreating ? s.creatingBranch : s.savingChanges,
          size: AppButtonSize.medium,
          isLoading: busy,
          onPressed: busy
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
      title: s.feedbackBranchDetailsTitle,
    );

    return AppAlert(
      feedback: AppFeedback(
        kind: feedback.kind,
        title: feedback.title,
        message: error.kind == AppErrorKind.notFound
            ? s.branchGone
            : feedback.message,
        actionLabel: s.retry,
        onAction: () => context.read<BranchDetailsCubit>().reload(),
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

String? _serverError(UpdateBranchState state, String key) => switch (state) {
  UpdateBranchFailure(:final AppError error) => error.fieldError(key),
  _ => null,
};
