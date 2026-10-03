import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../branches/data/models/branch_model.dart';
import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../../laboratories/data/models/laboratory_menu_item.dart';
import '../data/models/test_category_model.dart';
import '../logic/test_category_details_cubit.dart';
import '../logic/test_category_form_cubit.dart';
import 'widgets/test_category_page_header.dart';

class TestCategoryFormView extends StatelessWidget {
  const TestCategoryFormView({
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
      BlocProvider<TestCategoryDetailsCubit>(
        create: (_) {
          final TestCategoryDetailsCubit cubit =
              getIt<TestCategoryDetailsCubit>();
          if (id != null) cubit.load(id);
          return cubit;
        },
      ),
      BlocProvider<TestCategoryFormCubit>(
        create: (_) => getIt<TestCategoryFormCubit>()..loadLaboratories(),
      ),
    ],
    child: TestCategoryFormView(
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
        BlocListener<TestCategoryDetailsCubit, TestCategoryDetailsState>(
          listenWhen:
              (
                TestCategoryDetailsState previous,
                TestCategoryDetailsState next,
              ) => next is TestCategoryDetailsLoaded,
          listener: (BuildContext context, TestCategoryDetailsState state) {
            final TestCategoryModel category =
                (state as TestCategoryDetailsLoaded).category;
            context.read<TestCategoryFormCubit>().seed(
              category,
              context.appLocale,
            );
          },
        ),
        BlocListener<TestCategoryFormCubit, TestCategoryFormState>(
          listenWhen:
              (TestCategoryFormState previous, TestCategoryFormState next) =>
                  next is TestCategoryFormSaved ||
                  next is TestCategoryFormCreated,
          listener: (BuildContext context, TestCategoryFormState state) =>
              switch (state) {
                TestCategoryFormSaved() => onSaved(),
                _ => onCreated(),
              },
        ),
      ],
      child: HomePageFrame(
        maxWidth: AppSizes.pageFormMaxWidth,
        child: BlocBuilder<TestCategoryDetailsCubit, TestCategoryDetailsState>(
          builder: (BuildContext context, TestCategoryDetailsState state) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TestCategoryPageHeader(
                    title: isCreating
                        ? s.createTestCategoryTitle
                        : s.editTestCategoryTitle,
                    subtitle: isCreating
                        ? s.createTestCategorySubtitle
                        : s.editTestCategorySubtitle,
                    onBack: onCancel,
                  ),
                  const SizedBox(height: AppSpacing.x3l),
                  if (isCreating)
                    _Form(onCancel: onCancel, isCreating: true)
                  else
                    switch (state) {
                      TestCategoryDetailsLoaded() => _Form(onCancel: onCancel),
                      TestCategoryDetailsFailure(:final AppError error) =>
                        _Failed(error: error),
                      TestCategoryDetailsInitial() ||
                      TestCategoryDetailsLoading() => const _Loading(),
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
            s.testCategoryDetailsTitle,
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
          const _DescriptionField(),
          const SizedBox(height: AppSpacing.lg),
          const _LaboratoryField(),
          const SizedBox(height: AppSpacing.lg),
          const _BranchField(),
          const SizedBox(height: AppSpacing.lg),
          const _LangField(),
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
    final TestCategoryFormCubit cubit = context.read<TestCategoryFormCubit>();
    final bool enabled = context.select(
      (TestCategoryFormCubit cubit) => !cubit.isBusy,
    );
    final String? serverError = context.select(
      (TestCategoryFormCubit cubit) => _serverError(cubit.state, 'name'),
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit.nameController.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.testCategoryNameLabel,
        controller: cubit.nameController,
        prefixIcon: Icons.science_outlined,
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

    if (name.isEmpty) return s.testCategoryNameRequired;
    if (name.length > 150) return s.testCategoryNameTooLong;
    return null;
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TestCategoryFormCubit cubit = context.read<TestCategoryFormCubit>();
    final bool enabled = context.select(
      (TestCategoryFormCubit cubit) => !cubit.isBusy,
    );
    final String? serverError = context.select(
      (TestCategoryFormCubit cubit) => _serverError(cubit.state, 'description'),
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit.descriptionController.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.testCategoryDescriptionLabel,
        controller: cubit.descriptionController,
        prefixIcon: Icons.notes_rounded,
        enabled: enabled,
        maxLength: 500,
        errorText: field.hasError
            ? _errorFor(cubit.descriptionController.text, s)
            : serverError,
        onChanged: (String value) {
          cubit.fieldEdited();
          field.didChange(value);
        },
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) =>
      value.trim().length > 500 ? s.testCategoryDescriptionTooLong : null;
}

class _LaboratoryField extends StatelessWidget {
  const _LaboratoryField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<TestCategoryFormCubit, TestCategoryFormState>(
      builder: (BuildContext context, TestCategoryFormState state) {
        final TestCategoryFormCubit cubit = context
            .read<TestCategoryFormCubit>();
        final List<LaboratoryMenuItem> laboratories = cubit.laboratories;
        final int? selected = cubit.laboratoryId;
        final bool known = laboratories.any(
          (LaboratoryMenuItem item) => item.id == selected,
        );

        return AppSelect<int>(
          label: s.branchLaboratoryLabel,
          value: known ? selected : null,
          enabled: state is! TestCategoryFormLoading && laboratories.isNotEmpty,
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

    return BlocBuilder<TestCategoryFormCubit, TestCategoryFormState>(
      builder: (BuildContext context, TestCategoryFormState state) {
        final TestCategoryFormCubit cubit = context
            .read<TestCategoryFormCubit>();
        final List<BranchModel> branches = cubit.branches;
        final int? selected = cubit.branchId;
        final bool known = branches.any(
          (BranchModel branch) => branch.id == selected,
        );
        final bool hasLaboratory = cubit.laboratoryId != null;
        final bool empty =
            hasLaboratory && !cubit.branchesLoading && branches.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppSelect<int>(
              label: s.testCategoryBranchLabel,
              value: known ? selected : null,
              enabled:
                  state is! TestCategoryFormLoading &&
                  !cubit.branchesLoading &&
                  branches.isNotEmpty,
              errorText: _serverError(state, 'branch_id'),
              options: branches
                  .map(
                    (BranchModel branch) => AppSelectOption<int>(
                      value: branch.id,
                      label: branch.name,
                    ),
                  )
                  .toList(growable: false),
              onChanged: cubit.setBranch,
            ),
            if (empty) ...<Widget>[
              const SizedBox(height: AppSpacing.xs + 2),
              Text(
                s.testCategoryBranchEmpty,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.warning),
              ),
            ],
          ],
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
    final TestCategoryFormCubit cubit = context.read<TestCategoryFormCubit>();
    final bool enabled = context.select(
      (TestCategoryFormCubit cubit) => !cubit.isBusy,
    );
    final AppLocale lang = context.select(
      (TestCategoryFormCubit cubit) => cubit.lang,
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

class _FailureBanner extends StatelessWidget {
  const _FailureBanner();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<TestCategoryFormCubit, TestCategoryFormState>(
      builder: (BuildContext context, TestCategoryFormState state) {
        if (state is! TestCategoryFormFailure) {
          return const SizedBox(width: double.infinity);
        }

        final AppError error = state.error;
        final AppFeedback feedback = error.toFeedback(
          s,
          title: s.feedbackSaveTestCategoryTitle,
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
                  context.read<TestCategoryFormCubit>().dismissFailure(),
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
    final TestCategoryFormCubit cubit = context.read<TestCategoryFormCubit>();
    final bool busy = context.select(
      (TestCategoryFormCubit cubit) => cubit.isBusy,
    );
    final bool ready = context.select(
      (TestCategoryFormCubit cubit) =>
          cubit.laboratoryId != null && cubit.branchId != null,
    );

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
          loadingLabel: isCreating ? s.creatingTestCategory : s.savingChanges,
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
      title: s.feedbackTestCategoryDetailsTitle,
    );

    return AppAlert(
      feedback: AppFeedback(
        kind: feedback.kind,
        title: feedback.title,
        message: error.kind == AppErrorKind.notFound
            ? s.testCategoryGone
            : feedback.message,
        actionLabel: s.retry,
        onAction: () => context.read<TestCategoryDetailsCubit>().reload(),
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

String? _serverError(TestCategoryFormState state, String key) =>
    switch (state) {
      TestCategoryFormFailure(:final AppError error) => error.fieldError(key),
      _ => null,
    };
