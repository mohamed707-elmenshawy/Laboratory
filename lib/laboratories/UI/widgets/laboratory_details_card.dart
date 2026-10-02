import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/laboratory_model.dart';
import '../../logic/laboratory_status_cubit.dart';

class LaboratoryDetailsCard extends StatelessWidget {
  const LaboratoryDetailsCard({
    super.key,
    required this.laboratory,
    required this.onEdit,
  });

  final LaboratoryModel laboratory;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Row(label: s.laboratoryIdLabel, child: _Value('${laboratory.id}')),
          _Row(
            label: s.laboratoryAdminLabel,
            child: _Value(
              laboratory.admin?.trim().isNotEmpty == true
                  ? laboratory.admin!
                  : s.laboratoryAdminUnassigned,
              muted: laboratory.admin?.trim().isNotEmpty != true,
            ),
          ),
          _Row(
            label: s.laboratoryBranchesLabel,
            child: _Value('${laboratory.branchesCount}'),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(height: 1, thickness: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.xl),
          _StatusAction(laboratory: laboratory, onEdit: onEdit),
        ],
      ),
    );
  }
}

class _StatusAction extends StatelessWidget {
  const _StatusAction({required this.laboratory, required this.onEdit});

  final LaboratoryModel laboratory;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final LaboratoryStatusCubit cubit = context.read<LaboratoryStatusCubit>();

    return BlocBuilder<LaboratoryStatusCubit, LaboratoryStatusState>(
      builder: (BuildContext context, LaboratoryStatusState state) {
        final bool busy = state is LaboratoryStatusLoading;
        final bool isActive = laboratory.isActive;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (state is LaboratoryStatusFailure) ...<Widget>[
              AppAlert(
                feedback: _failureFeedback(state.error, s),
                onDismiss: cubit.reset,
                dismissTooltip: s.dismiss,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text(
              isActive ? s.deactivateLaboratoryHint : s.activateLaboratoryHint,
              style: base
                  .merge(AppTextStyles.caption)
                  .copyWith(color: AppColors.inkSubtle),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                AppButton(
                  label: s.edit,
                  icon: Icons.edit_outlined,
                  size: AppButtonSize.medium,
                  variant: AppButtonVariant.secondary,
                  onPressed: busy ? null : onEdit,
                ),
                const SizedBox(width: AppSpacing.md),
                AppButton(
                  label: isActive ? s.deactivate : s.activate,
                  loadingLabel: isActive ? s.deactivating : s.activating,
                  icon: isActive
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded,
                  size: AppButtonSize.medium,
                  variant: AppButtonVariant.secondary,
                  isLoading: busy,
                  onPressed: busy ? null : () => cubit.toggle(laboratory),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  AppFeedback _failureFeedback(AppError error, AppStrings s) =>
      error.toFeedback(
        s,
        title: laboratory.isActive
            ? s.feedbackDeactivateLaboratoryTitle
            : s.feedbackActivateLaboratoryTitle,
      );
}

class LaboratoryLogo extends StatelessWidget {
  const LaboratoryLogo({super.key, required this.url});

  static const double _size = 56;

  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.brandWash,
        borderRadius: AppRadius.mdAll,
      ),
      child: url == null
          ? const Icon(
              Icons.biotech_outlined,
              size: AppSizes.iconLg,
              color: AppColors.brand600,
            )
          : Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stack) =>
                      const Icon(
                        Icons.biotech_outlined,
                        size: AppSizes.iconLg,
                        color: AppColors.brand600,
                      ),
            ),
    );
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
