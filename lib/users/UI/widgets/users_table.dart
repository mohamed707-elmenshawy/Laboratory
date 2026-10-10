import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/models/named_ref.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/user_model.dart';

typedef UserCallback = void Function(UserModel user);

class UsersTable extends StatelessWidget {
  const UsersTable({
    super.key,
    required this.users,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  static const double _stackFrom = 980;
  static const double actionsWidth = 136;

  final List<UserModel> users;
  final UserCallback onView;
  final UserCallback onEdit;
  final UserCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stacked = constraints.maxWidth < _stackFrom;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!stacked) const _HeaderRow(),
            for (int i = 0; i < users.length; i++) ...<Widget>[
              if (i > 0 || !stacked)
                const Divider(height: 1, thickness: 1, color: AppColors.line),
              if (stacked)
                _StackedRow(
                  user: users[i],
                  onView: onView,
                  onEdit: onEdit,
                  onDelete: onDelete,
                )
              else
                _TableRow(
                  user: users[i],
                  onView: onView,
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
            ],
          ],
        );
      },
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return Container(
      color: AppColors.surfaceMuted,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: <Widget>[
          Expanded(flex: 4, child: _HeaderText(s.userNameLabel)),
          Expanded(flex: 3, child: _HeaderText(s.userRolesLabel)),
          Expanded(flex: 3, child: _HeaderText(s.branchLaboratoryLabel)),
          Expanded(flex: 3, child: _HeaderText(s.branchNameLabel)),
          SizedBox(
            width: UsersTable.actionsWidth,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _HeaderText(s.laboratoryActionsLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: base
          .merge(AppTextStyles.caption)
          .copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.inkSubtle,
          ),
    );
  }
}

class _TableRow extends StatefulWidget {
  const _TableRow({
    required this.user,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final UserModel user;
  final UserCallback onView;
  final UserCallback onEdit;
  final UserCallback onDelete;

  @override
  State<_TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final UserModel user = widget.user;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppMotion.resolve(context, AppMotion.fast),
        curve: AppMotion.curve,
        color: _hovered ? AppColors.ground : AppColors.surface,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            Expanded(flex: 4, child: _IdentityCell(user: user)),
            Expanded(flex: 3, child: _RolesCell(roles: user.roles)),
            Expanded(flex: 3, child: _RefCell(value: user.laboratory)),
            Expanded(flex: 3, child: _RefCell(value: user.branch)),
            SizedBox(
              width: UsersTable.actionsWidth,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: _RowActions(
                  onView: () => widget.onView(user),
                  onEdit: () => widget.onEdit(user),
                  onDelete: () => widget.onDelete(user),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StackedRow extends StatelessWidget {
  const _StackedRow({
    required this.user,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final UserModel user;
  final UserCallback onView;
  final UserCallback onEdit;
  final UserCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _IdentityCell(user: user),
          const SizedBox(height: AppSpacing.sm),
          _RolesCell(roles: user.roles),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: _StackedField(
                  label: s.branchLaboratoryLabel,
                  child: _RefCell(value: user.laboratory),
                ),
              ),
              Expanded(
                child: _StackedField(
                  label: s.branchNameLabel,
                  child: _RefCell(value: user.branch),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _RowActions(
              onView: () => onView(user),
              onEdit: () => onEdit(user),
              onDelete: () => onDelete(user),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowActions extends StatelessWidget {
  const _RowActions({
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _RowAction(
          icon: Icons.visibility_outlined,
          tooltip: s.view,
          onPressed: onView,
        ),
        _RowAction(
          icon: Icons.edit_outlined,
          tooltip: s.edit,
          onPressed: onEdit,
        ),
        _RowAction(
          icon: Icons.delete_outline_rounded,
          tooltip: s.delete,
          color: AppColors.danger,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: AppSizes.iconMd,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: AppSizes.hitTarget,
        height: AppSizes.hitTarget,
      ),
      hoverColor: AppColors.brandWash,
      icon: Icon(icon, color: color ?? AppColors.inkMuted),
    );
  }
}

class _StackedField extends StatelessWidget {
  const _StackedField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[_HeaderText(label), const SizedBox(height: 2), child],
    );
  }
}

class _IdentityCell extends StatelessWidget {
  const _IdentityCell({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Row(
      children: <Widget>[
        AppAvatar(name: user.name, size: AppSizes.controlSmall),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: base
                          .merge(AppTextStyles.body)
                          .copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                    ),
                  ),
                  if (!user.isVerified) ...<Widget>[
                    const SizedBox(width: AppSpacing.sm),
                    const _UnverifiedDot(),
                  ],
                ],
              ),
              Text(
                user.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.inkFaint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnverifiedDot extends StatelessWidget {
  const _UnverifiedDot();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return Tooltip(
      message: s.userUnverified,
      child: const Icon(
        Icons.schedule_rounded,
        size: AppSizes.iconSm,
        color: AppColors.warning,
      ),
    );
  }
}

class _RolesCell extends StatelessWidget {
  const _RolesCell({required this.roles});

  final List<String> roles;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    if (roles.isEmpty) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          s.notAssigned,
          style: base
              .merge(AppTextStyles.body)
              .copyWith(color: AppColors.inkFaint),
        ),
      );
    }

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: <Widget>[
          for (final String role in roles)
            AppPill(label: s.roleLabel(role), tone: _toneOf(role)),
        ],
      ),
    );
  }

  static AppPillTone _toneOf(String role) => switch (role) {
    'super-admin' => AppPillTone.brand,
    'team-member' => AppPillTone.warning,
    'laboratory-admin' => AppPillTone.success,
    _ => AppPillTone.neutral,
  };
}

class _RefCell extends StatelessWidget {
  const _RefCell({required this.value});

  final NamedRef? value;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool has = value != null && value!.name.trim().isNotEmpty;

    return Text(
      has ? value!.name : s.notAssigned,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: base
          .merge(AppTextStyles.body)
          .copyWith(color: has ? AppColors.inkMuted : AppColors.inkFaint),
    );
  }
}
