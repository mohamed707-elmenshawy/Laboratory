import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/models/named_ref.dart';
import '../../core/phones/phones.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../data/models/user_model.dart';
import '../logic/user_details_cubit.dart';
import 'widgets/user_page_header.dart';

class UserDetailsView extends StatelessWidget {
  const UserDetailsView({
    super.key,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
  });

  static Widget page({
    required int id,
    required VoidCallback onBack,
    required ValueChanged<UserModel> onEdit,
    required ValueChanged<UserModel> onDelete,
  }) => BlocProvider<UserDetailsCubit>(
    create: (_) => getIt<UserDetailsCubit>()..load(id),
    child: UserDetailsView(onBack: onBack, onEdit: onEdit, onDelete: onDelete),
  );

  final VoidCallback onBack;
  final ValueChanged<UserModel> onEdit;
  final ValueChanged<UserModel> onDelete;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return HomePageFrame(
      maxWidth: AppSizes.pageFormMaxWidth,
      child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
        builder: (BuildContext context, UserDetailsState state) {
          final UserModel? user = switch (state) {
            UserDetailsLoaded(:final UserModel user) => user,
            _ => null,
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserPageHeader(
                title: user?.name ?? s.userDetailsTitle,
                subtitle: s.userDetailsSubtitle,
                onBack: onBack,
                trailing: user == null
                    ? null
                    : AppPill(
                        label: user.isVerified
                            ? s.userVerified
                            : s.userUnverified,
                        tone: user.isVerified
                            ? AppPillTone.success
                            : AppPillTone.warning,
                        icon: user.isVerified
                            ? Icons.verified_outlined
                            : Icons.schedule_rounded,
                      ),
              ),
              const SizedBox(height: AppSpacing.x3l),
              switch (state) {
                UserDetailsLoaded(:final UserModel user) => _Loaded(
                  user: user,
                  onEdit: () => onEdit(user),
                  onDelete: () => onDelete(user),
                ),
                UserDetailsFailure(:final AppError error) => _Failed(
                  error: error,
                ),
                UserDetailsInitial() ||
                UserDetailsLoading() => const _Loading(),
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
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  final UserModel user;
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
            label: s.userEmailLabel,
            child: _Value(user.email, direction: TextDirection.ltr),
          ),
          _Row(
            label: s.userRolesLabel,
            child: _Chips(values: user.roles),
          ),
          _Row(
            label: s.branchLaboratoryLabel,
            child: _RefValue(value: user.laboratory),
          ),
          _Row(
            label: s.branchNameLabel,
            child: _RefValue(value: user.branch),
          ),
          if (user.commissionPercentage != null)
            _Row(
              label: s.userCommissionLabel,
              child: _Value('${user.commissionPercentage}%'),
            ),
          _Row(
            label: s.branchPhonesLabel,
            child: _Phones(user: user),
          ),
          _Row(
            label: s.userPermissionsLabel,
            child: _Permissions(values: user.permissions),
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

class _Phones extends StatelessWidget {
  const _Phones({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    if (user.phones.isEmpty) {
      return _Value(s.notAssigned, muted: true);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final PhoneModel phone in user.phones)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: <Widget>[
                Text(
                  '${phone.dialCode ?? ''} ${phone.phone}'.trim(),
                  textDirection: TextDirection.ltr,
                  style: base
                      .merge(AppTextStyles.body)
                      .copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink,
                      ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppPill(
                  label: phone.typeLabel ?? _typeLabel(phone, s),
                  tone: AppPillTone.neutral,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

String _typeLabel(PhoneModel phone, AppStrings s) => switch (phone.type) {
  'both' => s.phoneTypeBoth,
  'phone' => s.phoneTypePhone,
  'whatsapp' => s.phoneTypeWhatsapp,
  _ => phone.type ?? '',
};

class _Chips extends StatelessWidget {
  const _Chips({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    if (values.isEmpty) return _Value(s.notAssigned, muted: true);

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: <Widget>[
        for (final String value in values)
          AppPill(label: s.roleLabel(value), tone: AppPillTone.brand),
      ],
    );
  }
}

class _Permissions extends StatelessWidget {
  const _Permissions({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    if (values.isEmpty) return _Value(s.userNoPermissions, muted: true);

    return Text(
      s.userPermissionsCount(values.length),
      style: base.merge(AppTextStyles.body).copyWith(color: AppColors.inkMuted),
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
  const _Value(this.value, {this.muted = false, this.direction});

  final String value;
  final bool muted;
  final TextDirection? direction;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Text(
      value,
      textDirection: direction,
      style: base
          .merge(AppTextStyles.body)
          .copyWith(
            fontWeight: muted ? FontWeight.w400 : FontWeight.w500,
            color: muted ? AppColors.inkFaint : AppColors.ink,
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
