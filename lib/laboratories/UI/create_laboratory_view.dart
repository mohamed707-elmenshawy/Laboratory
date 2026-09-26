import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../logic/create_laboratory_cubit.dart';
import 'widgets/laboratory_form_header.dart';

class CreateLaboratoryView extends StatelessWidget {
  const CreateLaboratoryView({
    super.key,
    required this.onCancel,
    required this.onCreated,
  });

  static Widget page({
    required AppLocale lang,
    required VoidCallback onCancel,
    required VoidCallback onCreated,
  }) => BlocProvider<CreateLaboratoryCubit>(
    create: (_) => getIt<CreateLaboratoryCubit>()..start(lang),
    child: CreateLaboratoryView(onCancel: onCancel, onCreated: onCreated),
  );

  final VoidCallback onCancel;
  final VoidCallback onCreated;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocListener<CreateLaboratoryCubit, CreateLaboratoryState>(
      listenWhen:
          (CreateLaboratoryState previous, CreateLaboratoryState next) =>
              next is CreateLaboratorySuccess,
      listener: (BuildContext context, CreateLaboratoryState state) =>
          onCreated(),
      child: HomePageFrame(
        maxWidth: AppSizes.pageFormMaxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LaboratoryFormHeader(
              title: s.createLaboratoryTitle,
              subtitle: s.createLaboratorySubtitle,
              onBack: onCancel,
            ),
            const SizedBox(height: AppSpacing.x3l),
            _FormCard(onCancel: onCancel),
          ],
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return AppCard(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              s.laboratoryDetailsTitle,
              style: base
                  .merge(AppTextStyles.label)
                  .copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _FailureBanner(),
            const _NameField(),
            const SizedBox(height: AppSpacing.lg),
            const _LangField(),
            const SizedBox(height: AppSpacing.xl),
            _Actions(onCancel: onCancel),
          ],
        ),
      ),
    );
  }
}

class _FailureBanner extends StatelessWidget {
  const _FailureBanner();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<CreateLaboratoryCubit, CreateLaboratoryState>(
      builder: (BuildContext context, CreateLaboratoryState state) {
        if (state is! CreateLaboratoryFailure) {
          return const SizedBox(width: double.infinity);
        }

        final AppError error = state.error;
        final AppFeedback feedback = error.toFeedback(
          s,
          title: s.feedbackCreateLaboratoryTitle,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppAlert(
              feedback: feedback,
              onDismiss: () =>
                  context.read<CreateLaboratoryCubit>().dismissFailure(),
              dismissTooltip: s.dismiss,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        );
      },
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final CreateLaboratoryCubit cubit = context.read<CreateLaboratoryCubit>();
    final bool enabled = context.select(
      (CreateLaboratoryCubit cubit) => !cubit.isBusy,
    );
    final String? serverError = context.select(
      (CreateLaboratoryCubit cubit) => switch (cubit.state) {
        CreateLaboratoryFailure(:final AppError error) => error.fieldError(
          'name',
        ),
        _ => null,
      },
    );

    return FormField<String>(
      validator: (_) => _errorFor(cubit.nameController.text, s),
      builder: (FormFieldState<String> field) => AppTextField(
        label: s.laboratoryNameLabel,
        hint: s.laboratoryNameHint,
        controller: cubit.nameController,
        prefixIcon: Icons.biotech_outlined,
        enabled: enabled,
        autofocus: true,
        maxLength: 255,
        textInputAction: TextInputAction.done,
        errorText: field.hasError
            ? _errorFor(cubit.nameController.text, s)
            : serverError,
        onChanged: (String value) {
          cubit.nameEdited();
          field.didChange(value);
        },
        onSubmitted: (_) {
          if (Form.of(context).validate()) cubit.save();
        },
      ),
    );
  }

  static String? _errorFor(String value, AppStrings s) {
    final String name = value.trim();

    if (name.isEmpty) return s.laboratoryNameRequired;
    if (name.length > 255) return s.nameTooLong;
    return null;
  }
}

class _LangField extends StatelessWidget {
  const _LangField();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final LabSettings settings = context.labSettings;
    final CreateLaboratoryCubit cubit = context.read<CreateLaboratoryCubit>();

    final AppLocale lang = context.select(
      (CreateLaboratoryCubit cubit) => cubit.lang,
    );
    final bool enabled = context.select(
      (CreateLaboratoryCubit cubit) => !cubit.isBusy,
    );
    final String? serverError = context.select(
      (CreateLaboratoryCubit cubit) => switch (cubit.state) {
        CreateLaboratoryFailure(:final AppError error) => error.fieldError(
          'lang',
        ),
        _ => null,
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppSelect<AppLocale>(
          label: s.laboratoryNameLanguageLabel,
          value: settings.availableLocales.contains(lang)
              ? lang
              : settings.availableLocales.first,
          enabled: enabled,
          errorText: serverError,
          options: settings.availableLocales
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
          s.laboratoryNameLanguageHint,
          style: base
              .merge(AppTextStyles.caption)
              .copyWith(color: AppColors.inkSubtle),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final CreateLaboratoryCubit cubit = context.read<CreateLaboratoryCubit>();
    final bool busy = context.select(
      (CreateLaboratoryCubit cubit) => cubit.isBusy,
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
          label: s.create,
          loadingLabel: s.creatingLaboratory,
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
