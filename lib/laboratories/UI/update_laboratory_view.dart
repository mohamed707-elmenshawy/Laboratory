import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../data/models/laboratory_model.dart';
import '../data/models/update_laboratory_request_body.dart';
import '../logic/laboratory_details_cubit.dart';
import '../logic/update_laboratory_cubit.dart';
import 'laboratory_logo_picker.dart';
import 'widgets/laboratory_details_card.dart';
import 'widgets/laboratory_form_header.dart';

class UpdateLaboratoryView extends StatelessWidget {
  const UpdateLaboratoryView({
    super.key,
    required this.onCancel,
    required this.onSaved,
    this.pickLogo = pickLaboratoryLogo,
  });

  static Widget page({
    required int id,
    required VoidCallback onCancel,
    required ValueChanged<LaboratoryModel> onSaved,
    LaboratoryLogoPicker pickLogo = pickLaboratoryLogo,
  }) => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<LaboratoryDetailsCubit>(
        create: (_) => getIt<LaboratoryDetailsCubit>()..load(id),
      ),
      BlocProvider<UpdateLaboratoryCubit>(
        create: (_) => getIt<UpdateLaboratoryCubit>(),
      ),
    ],
    child: UpdateLaboratoryView(
      onCancel: onCancel,
      onSaved: onSaved,
      pickLogo: pickLogo,
    ),
  );

  final VoidCallback onCancel;
  final ValueChanged<LaboratoryModel> onSaved;
  final LaboratoryLogoPicker pickLogo;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<LaboratoryDetailsCubit, LaboratoryDetailsState>(
          listenWhen:
              (LaboratoryDetailsState previous, LaboratoryDetailsState next) =>
                  next is LaboratoryDetailsLoaded,
          listener: (BuildContext context, LaboratoryDetailsState state) {
            final LaboratoryModel laboratory =
                (state as LaboratoryDetailsLoaded).laboratory;
            context.read<UpdateLaboratoryCubit>().seed(
              laboratory,
              context.appLocale,
            );
          },
        ),
        BlocListener<UpdateLaboratoryCubit, UpdateLaboratoryState>(
          listenWhen:
              (UpdateLaboratoryState previous, UpdateLaboratoryState next) =>
                  next is UpdateLaboratorySuccess,
          listener: (BuildContext context, UpdateLaboratoryState state) {
            final LaboratoryModel laboratory =
                (state as UpdateLaboratorySuccess).laboratory;
            onSaved(laboratory);
          },
        ),
      ],
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
                  title: s.editLaboratoryTitle,
                  subtitle: s.editLaboratorySubtitle,
                  onBack: onCancel,
                  leading: laboratory == null ? null : const _HeaderLogo(),
                ),
                const SizedBox(height: AppSpacing.x3l),
                switch (state) {
                  LaboratoryDetailsLoaded() => _Form(
                    onCancel: onCancel,
                    pickLogo: pickLogo,
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

class _Form extends StatelessWidget {
  const _Form({required this.onCancel, required this.pickLogo});

  final VoidCallback onCancel;
  final LaboratoryLogoPicker pickLogo;

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
            const SizedBox(height: AppSpacing.lg),
            _LogoField(pickLogo: pickLogo),
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

    return BlocBuilder<UpdateLaboratoryCubit, UpdateLaboratoryState>(
      builder: (BuildContext context, UpdateLaboratoryState state) {
        if (state is! UpdateLaboratoryFailure) {
          return const SizedBox(width: double.infinity);
        }

        final AppError error = state.error;
        final AppFeedback feedback = error.toFeedback(
          s,
          title: s.feedbackUpdateLaboratoryTitle,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppAlert(
              feedback: feedback,
              onDismiss: () =>
                  context.read<UpdateLaboratoryCubit>().dismissFailure(),
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
    final UpdateLaboratoryCubit cubit = context.read<UpdateLaboratoryCubit>();
    final bool enabled = context.select(
      (UpdateLaboratoryCubit cubit) => !cubit.isBusy,
    );
    final String? serverError = context.select(
      (UpdateLaboratoryCubit cubit) => switch (cubit.state) {
        UpdateLaboratoryFailure(:final AppError error) => error.fieldError(
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
    final UpdateLaboratoryCubit cubit = context.read<UpdateLaboratoryCubit>();

    final AppLocale lang = context.select(
      (UpdateLaboratoryCubit cubit) => cubit.lang,
    );
    final bool enabled = context.select(
      (UpdateLaboratoryCubit cubit) => !cubit.isBusy,
    );
    final String? serverError = context.select(
      (UpdateLaboratoryCubit cubit) => switch (cubit.state) {
        UpdateLaboratoryFailure(:final AppError error) => error.fieldError(
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

class _LogoField extends StatelessWidget {
  const _LogoField({required this.pickLogo});

  final LaboratoryLogoPicker pickLogo;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final UpdateLaboratoryCubit cubit = context.read<UpdateLaboratoryCubit>();

    final LaboratoryLogoFile? logo = context.select(
      (UpdateLaboratoryCubit cubit) => cubit.logo,
    );
    final String? currentLogoUrl = context.select(
      (UpdateLaboratoryCubit cubit) => cubit.currentLogoUrl,
    );
    final bool enabled = context.select(
      (UpdateLaboratoryCubit cubit) => !cubit.isBusy,
    );
    final String? localError = context.select(
      (UpdateLaboratoryCubit cubit) => cubit.logoError,
    );
    final String? serverError =
        localError ??
        context.select(
          (UpdateLaboratoryCubit cubit) => switch (cubit.state) {
            UpdateLaboratoryFailure(:final AppError error) => error.fieldError(
              'logo',
            ),
            _ => null,
          },
        );

    final bool hasCurrent =
        currentLogoUrl != null && currentLogoUrl.trim().isNotEmpty;
    final String actionLabel = logo != null || hasCurrent
        ? s.changeLogo
        : s.chooseLogo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          s.laboratoryLogoLabel,
          style: base
              .merge(AppTextStyles.label)
              .copyWith(fontSize: 13, color: AppColors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _LogoPreview(file: logo, url: currentLogoUrl),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    logo?.filename ?? s.laboratoryLogoHint,
                    style: base
                        .merge(AppTextStyles.caption)
                        .copyWith(color: AppColors.inkSubtle),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      AppButton(
                        label: actionLabel,
                        icon: Icons.image_outlined,
                        size: AppButtonSize.small,
                        variant: AppButtonVariant.secondary,
                        onPressed: enabled ? () => _pick(context, cubit) : null,
                      ),
                      if (logo != null)
                        AppButton(
                          label: s.clearLogo,
                          size: AppButtonSize.small,
                          variant: AppButtonVariant.ghost,
                          onPressed: enabled ? cubit.clearLogo : null,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (serverError != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            serverError,
            style: base
                .merge(AppTextStyles.caption)
                .copyWith(fontSize: 12.5, color: AppColors.danger),
          ),
        ],
      ],
    );
  }

  Future<void> _pick(BuildContext context, UpdateLaboratoryCubit cubit) async {
    final AppStrings s = context.strings;
    final LaboratoryLogoResult? result = await pickLogo();

    if (result == null || !context.mounted) return;

    if (result.tooLarge) {
      cubit.logoRejected(s.logoTooLarge);
      return;
    }

    final LaboratoryLogoFile? file = result.file;
    if (file != null) cubit.setLogo(file);
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo();

  @override
  Widget build(BuildContext context) {
    final LaboratoryLogoFile? logo = context.select(
      (UpdateLaboratoryCubit cubit) => cubit.logo,
    );
    final String? currentLogoUrl = context.select(
      (UpdateLaboratoryCubit cubit) => cubit.currentLogoUrl,
    );

    return _LogoPreview(file: logo, url: currentLogoUrl);
  }
}

class _LogoPreview extends StatelessWidget {
  const _LogoPreview({required this.file, required this.url});

  static const double _size = 56;

  final LaboratoryLogoFile? file;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final LaboratoryLogoFile? selected = file;
    if (selected == null) return LaboratoryLogo(url: url);

    return Container(
      width: _size,
      height: _size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.brandWash,
        borderRadius: AppRadius.mdAll,
      ),
      child: _isSvg(selected.filename)
          ? const Icon(
              Icons.image_outlined,
              size: AppSizes.iconLg,
              color: AppColors.brand600,
            )
          : Image.memory(
              selected.bytes,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stack) =>
                      const Icon(
                        Icons.image_outlined,
                        size: AppSizes.iconLg,
                        color: AppColors.brand600,
                      ),
            ),
    );
  }

  static bool _isSvg(String filename) =>
      filename.toLowerCase().endsWith('.svg');
}

class _Actions extends StatelessWidget {
  const _Actions({required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UpdateLaboratoryCubit cubit = context.read<UpdateLaboratoryCubit>();
    final bool busy = context.select(
      (UpdateLaboratoryCubit cubit) => cubit.isBusy,
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
          label: s.saveChanges,
          loadingLabel: s.savingChanges,
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
