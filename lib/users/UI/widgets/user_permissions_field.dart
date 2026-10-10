import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/user_form_cubit.dart';

class UserPermissionsField extends StatefulWidget {
  const UserPermissionsField({super.key, this.serverError});

  static const double listMaxHeight = 280;

  final String? serverError;

  @override
  State<UserPermissionsField> createState() => _UserPermissionsFieldState();
}

class _UserPermissionsFieldState extends State<UserPermissionsField> {
  final TextEditingController _search = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final Set<String> _collapsed = <String>{};

  String _term = '';

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Map<String, List<String>> _grouped(List<String> permissions) {
    final Map<String, List<String>> groups = <String, List<String>>{};

    for (final String permission in permissions) {
      if (_term.isNotEmpty && !permission.toLowerCase().contains(_term)) {
        continue;
      }

      final int dot = permission.indexOf('.');
      final String group = dot == -1
          ? permission
          : permission.substring(0, dot);
      groups.putIfAbsent(group, () => <String>[]).add(permission);
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return BlocBuilder<UserFormCubit, UserFormState>(
      builder: (BuildContext context, UserFormState state) {
        final UserFormCubit cubit = context.read<UserFormCubit>();
        final bool enabled = state is! UserFormLoading;
        final List<String> selected = cubit.permissions;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    s.userPermissionsLabel,
                    style: base
                        .merge(AppTextStyles.label)
                        .copyWith(color: AppColors.inkSubtle),
                  ),
                ),
                if (selected.isNotEmpty) ...<Widget>[
                  Text(
                    s.userPermissionsSelected(selected.length),
                    style: base
                        .merge(AppTextStyles.caption)
                        .copyWith(color: AppColors.brand600),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppTextLink(
                    label: s.clearSelection,
                    onPressed: enabled ? cubit.clearPermissions : null,
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              s.userPermissionsHint,
              style: base
                  .merge(AppTextStyles.caption)
                  .copyWith(color: AppColors.inkSubtle),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (cubit.grantableLoading)
              const _Loading()
            else if (cubit.grantableFailed)
              _Failed(onRetry: cubit.loadGrantablePermissions)
            else if (cubit.grantablePermissions.isEmpty)
              Text(
                s.userPermissionsUnavailable,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.inkSubtle),
              )
            else
              _Picker(
                groups: _grouped(cubit.grantablePermissions),
                selected: selected,
                collapsed: _collapsed,
                enabled: enabled,
                search: _search,
                scroll: _scroll,
                onSearch: (String value) =>
                    setState(() => _term = value.trim().toLowerCase()),
                onToggleGroup: (String group) => setState(() {
                  if (!_collapsed.remove(group)) _collapsed.add(group);
                }),
                onToggle: cubit.togglePermission,
                onToggleAll: cubit.togglePermissionGroup,
              ),
            if (widget.serverError case final String error) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                error,
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

class _Picker extends StatelessWidget {
  const _Picker({
    required this.groups,
    required this.selected,
    required this.collapsed,
    required this.enabled,
    required this.search,
    required this.scroll,
    required this.onSearch,
    required this.onToggleGroup,
    required this.onToggle,
    required this.onToggleAll,
  });

  final Map<String, List<String>> groups;
  final List<String> selected;
  final Set<String> collapsed;
  final bool enabled;
  final TextEditingController search;
  final ScrollController scroll;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onToggleGroup;
  final ValueChanged<String> onToggle;
  final void Function(List<String> group, bool selected) onToggleAll;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.line, width: AppSizes.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: AppSearchField(
              hint: s.searchPermissionsHint,
              initialValue: search.text,
              debounce: const Duration(milliseconds: 180),
              onSubmitted: onSearch,
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.line),
          if (groups.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                s.permissionsNoMatch,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.inkSubtle),
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: UserPermissionsField.listMaxHeight,
              ),
              child: Scrollbar(
                controller: scroll,
                child: ListView(
                  controller: scroll,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  children: <Widget>[
                    for (final MapEntry<String, List<String>> entry
                        in groups.entries)
                      _Group(
                        name: entry.key,
                        permissions: entry.value,
                        selected: selected,
                        collapsed: collapsed.contains(entry.key),
                        enabled: enabled,
                        onHeaderTap: () => onToggleGroup(entry.key),
                        onToggle: onToggle,
                        onToggleAll: onToggleAll,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({
    required this.name,
    required this.permissions,
    required this.selected,
    required this.collapsed,
    required this.enabled,
    required this.onHeaderTap,
    required this.onToggle,
    required this.onToggleAll,
  });

  final String name;
  final List<String> permissions;
  final List<String> selected;
  final bool collapsed;
  final bool enabled;
  final VoidCallback onHeaderTap;
  final ValueChanged<String> onToggle;
  final void Function(List<String> group, bool selected) onToggleAll;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final int chosen = permissions
        .where((String permission) => selected.contains(permission))
        .length;
    final bool all = chosen == permissions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: onHeaderTap,
          borderRadius: AppRadius.smAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: <Widget>[
                Icon(
                  collapsed
                      ? Icons.chevron_right_rounded
                      : Icons.expand_more_rounded,
                  size: AppSizes.iconMd,
                  color: AppColors.inkFaint,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    _label(name),
                    style: base
                        .merge(AppTextStyles.label)
                        .copyWith(fontSize: 13, color: AppColors.ink),
                  ),
                ),
                if (chosen > 0)
                  AppPill(label: '$chosen', tone: AppPillTone.brand),
                const SizedBox(width: AppSpacing.sm),
                AppTextLink(
                  label: all ? s.deselectAll : s.selectAll,
                  onPressed: enabled
                      ? () => onToggleAll(permissions, !all)
                      : null,
                ),
              ],
            ),
          ),
        ),
        if (!collapsed)
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppSpacing.xl,
              bottom: AppSpacing.sm,
            ),
            child: Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.xs,
              children: <Widget>[
                for (final String permission in permissions)
                  AppCheckbox(
                    value: selected.contains(permission),
                    enabled: enabled,
                    label: _action(permission),
                    semanticLabel: permission,
                    onChanged: (_) => onToggle(permission),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  static String _label(String group) =>
      group.replaceAll('-', ' ').replaceAll('_', ' ');

  static String _action(String permission) {
    final int dot = permission.indexOf('.');
    final String action = dot == -1
        ? permission
        : permission.substring(dot + 1);

    return action.replaceAll('-', ' ');
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Row(
      children: <Widget>[
        const SizedBox(
          width: AppSizes.iconMd,
          height: AppSizes.iconMd,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.brand600,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          s.loadingPermissions,
          style: base
              .merge(AppTextStyles.caption)
              .copyWith(color: AppColors.inkSubtle),
        ),
      ],
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return AppAlert(
      feedback: AppFeedback.danger(
        title: s.feedbackPermissionsTitle,
        message: s.feedbackPermissionsMessage,
        actionLabel: s.retry,
        onAction: onRetry,
      ),
    );
  }
}
