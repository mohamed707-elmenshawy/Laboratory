import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/models/named_ref.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../data/models/test_category_model.dart';
import '../logic/test_category_details_cubit.dart';
import 'widgets/test_category_page_header.dart';

class TestCategoryDetailsView extends StatelessWidget {
  const TestCategoryDetailsView({
    super.key,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
  });

  static Widget page({
    required int id,
    required VoidCallback onBack,
    required ValueChanged<TestCategoryModel> onEdit,
    required ValueChanged<TestCategoryModel> onDelete,
  }) => BlocProvider<TestCategoryDetailsCubit>(
    create: (_) => getIt<TestCategoryDetailsCubit>()..load(id),
    child: TestCategoryDetailsView(
      onBack: onBack,
      onEdit: onEdit,
      onDelete: onDelete,
    ),
  );

  final VoidCallback onBack;
  final ValueChanged<TestCategoryModel> onEdit;
  final ValueChanged<TestCategoryModel> onDelete;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return HomePageFrame(
      maxWidth: AppSizes.pageFormMaxWidth,
      child: BlocBuilder<TestCategoryDetailsCubit, TestCategoryDetailsState>(
        builder: (BuildContext context, TestCategoryDetailsState state) {
          final TestCategoryModel? category = switch (state) {
            TestCategoryDetailsLoaded(:final TestCategoryModel category) =>
              category,
            _ => null,
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TestCategoryPageHeader(
                title: category?.name ?? s.testCategoryDetailsTitle,
                subtitle: s.testCategoryDetailsSubtitle,
                onBack: onBack,
                trailing: category == null
                    ? null
                    : AppPill(
                        label: category.isActive
                            ? s.statusActive
                            : s.statusInactive,
                        tone: category.isActive
                            ? AppPillTone.success
                            : AppPillTone.neutral,
                        icon: category.isActive
                            ? Icons.check_circle_rounded
                            : Icons.pause_circle_outline_rounded,
                      ),
              ),
              const SizedBox(height: AppSpacing.x3l),
              switch (state) {
                TestCategoryDetailsLoaded(:final TestCategoryModel category) =>
                  _Loaded(
                    category: category,
                    onEdit: () => onEdit(category),
                    onDelete: () => onDelete(category),
                  ),
                TestCategoryDetailsFailure(:final AppError error) => _Failed(
                  error: error,
                ),
                TestCategoryDetailsInitial() ||
                TestCategoryDetailsLoading() => const _Loading(),
              },
            ],
          );
        },
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  final TestCategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Row(
            label: s.testCategoryDescriptionLabel,
            child: _Value(
              category.description?.trim().isNotEmpty == true
                  ? category.description!
                  : s.noDescription,
              muted: category.description?.trim().isNotEmpty != true,
            ),
          ),
          _Row(
            label: s.branchLaboratoryLabel,
            child: _RefValue(value: category.laboratory),
          ),
          _Row(
            label: s.branchNameLabel,
            child: _RefValue(value: category.branch),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(height: 1, thickness: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AppButton(
                label: s.edit,
                icon: Icons.edit_outlined,
                size: AppButtonSize.medium,
                variant: AppButtonVariant.secondary,
                onPressed: onEdit,
              ),
              const SizedBox(width: AppSpacing.md),
              AppButton(
                label: s.delete,
                icon: Icons.delete_outline_rounded,
                size: AppButtonSize.medium,
                variant: AppButtonVariant.danger,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RefValue extends StatelessWidget {
  const _RefValue({required this.value});

  final NamedRef? value;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool has = value != null && value!.name.trim().isNotEmpty;

    return _Value(has ? value!.name : s.notAssigned, muted: !has);
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: base
                  .merge(AppTextStyles.caption)
                  .copyWith(fontSize: 12.5, color: AppColors.inkSubtle),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _Value extends StatelessWidget {
  const _Value(this.value, {this.muted = false});

  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Text(
      value,
      style: base
          .merge(AppTextStyles.body)
          .copyWith(
            fontWeight: muted ? FontWeight.w400 : FontWeight.w500,
            color: muted ? AppColors.inkFaint : AppColors.ink,
          ),
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
