import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/phones/phones.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../data/models/branch_model.dart';
import '../logic/branch_details_cubit.dart';
import 'widgets/branch_page_header.dart';

class BranchDetailsView extends StatelessWidget {
  const BranchDetailsView({
    super.key,
    required this.onBack,
    required this.onEdit,
  });

  static Widget page({
    required int id,
    required VoidCallback onBack,
    required ValueChanged<BranchModel> onEdit,
  }) => BlocProvider<BranchDetailsCubit>(
    create: (_) => getIt<BranchDetailsCubit>()..load(id),
    child: BranchDetailsView(onBack: onBack, onEdit: onEdit),
  );

  final VoidCallback onBack;
  final ValueChanged<BranchModel> onEdit;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return HomePageFrame(
      maxWidth: AppSizes.pageFormMaxWidth,
      child: BlocBuilder<BranchDetailsCubit, BranchDetailsState>(
        builder: (BuildContext context, BranchDetailsState state) {
          final BranchModel? branch = switch (state) {
            BranchDetailsLoaded(:final BranchModel branch) => branch,
            _ => null,
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BranchPageHeader(
                title: branch?.name ?? s.branchDetailsTitle,
                subtitle: s.branchDetailsSubtitle,
                onBack: onBack,
                trailing: branch == null
                    ? null
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (branch.isMainBranch) ...<Widget>[
                            AppPill(
                              label: s.branchMainPill,
                              tone: AppPillTone.brand,
                              icon: Icons.star_rounded,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          AppPill(
                            label: branch.isActive
                                ? s.statusActive
                                : s.statusInactive,
                            tone: branch.isActive
                                ? AppPillTone.success
                                : AppPillTone.neutral,
                            icon: branch.isActive
                                ? Icons.check_circle_rounded
                                : Icons.pause_circle_outline_rounded,
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: AppSpacing.x3l),
              switch (state) {
                BranchDetailsLoaded(:final BranchModel branch) => _Loaded(
                  branch: branch,
                  onEdit: () => onEdit(branch),
                ),
                BranchDetailsFailure(:final AppError error) => _Failed(
                  error: error,
                ),
                BranchDetailsInitial() ||
                BranchDetailsLoading() => const _Loading(),
              },
            ],
          );
        },
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.branch, required this.onEdit});

  final BranchModel branch;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Row(
                label: s.branchLaboratoryLabel,
                child: _Value(branch.laboratory?.name ?? s.notAssigned),
              ),
              _Row(
                label: s.branchAddressLabel,
                child: _Value(
                  branch.address?.isNotEmpty == true
                      ? branch.address!
                      : s.notAssigned,
                  muted: branch.address?.isNotEmpty != true,
                ),
              ),
              _Row(
                label: s.branchManagerLabel,
                child: _Value(
                  branch.manager?.isNotEmpty == true
                      ? branch.manager!
                      : s.notAssigned,
                  muted: branch.manager?.isNotEmpty != true,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Divider(height: 1, thickness: 1, color: AppColors.line),
              const SizedBox(height: AppSpacing.xl),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AppButton(
                  label: s.editBranch,
                  icon: Icons.edit_outlined,
                  size: AppButtonSize.medium,
                  variant: AppButtonVariant.secondary,
                  onPressed: onEdit,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _PhonesCard(phones: branch.phones),
      ],
    );
  }
}

class _PhonesCard extends StatelessWidget {
  const _PhonesCard({required this.phones});

  final List<PhoneModel> phones;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            s.branchPhonesLabel,
            style: base
                .merge(AppTextStyles.label)
                .copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (phones.isEmpty)
            Text(
              s.phonesEmpty,
              style: base
                  .merge(AppTextStyles.body)
                  .copyWith(color: AppColors.inkSubtle),
            )
          else
            for (int i = 0; i < phones.length; i++) ...<Widget>[
              if (i > 0)
                const Divider(height: 1, thickness: 1, color: AppColors.line),
              _PhoneRow(phone: phones[i]),
            ],
        ],
      ),
    );
  }
}

class _PhoneRow extends StatelessWidget {
  const _PhoneRow({required this.phone});

  final PhoneModel phone;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: <Widget>[
          Icon(
            phone.type == 'whatsapp'
                ? Icons.chat_outlined
                : Icons.phone_outlined,
            size: AppSizes.iconMd,
            color: AppColors.inkSubtle,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              phone.phone,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.start,
              style: base
                  .merge(AppTextStyles.body)
                  .copyWith(fontWeight: FontWeight.w500, color: AppColors.ink),
            ),
          ),
          if (phone.phoneCountry != null) ...<Widget>[
            AppPill(label: phone.phoneCountry!),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            phone.typeLabel ?? _typeLabel(s),
            style: base
                .merge(AppTextStyles.caption)
                .copyWith(color: AppColors.inkSubtle),
          ),
        ],
      ),
    );
  }

  String _typeLabel(AppStrings s) => switch (phone.type) {
    'both' => s.phoneTypeBoth,
    'phone' => s.phoneTypePhone,
    'whatsapp' => s.phoneTypeWhatsapp,
    _ => phone.type ?? '',
  };
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
