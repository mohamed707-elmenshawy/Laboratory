import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/models/user_model.dart';
import '../../../core/ui/ui.dart';
import '../../logic/home_cubit.dart';
import '../../logic/logout_cubit.dart';
import 'home_destination.dart';

class HomeUserMenu extends StatelessWidget {
  const HomeUserMenu({super.key, required this.onNavigate});

  final ValueChanged<HomeDestination> onNavigate;

  static const double _menuWidth = 296;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final UserModel? user = context.select((HomeCubit cubit) => cubit.user);
    final bool busy = context.select((LogoutCubit cubit) => cubit.isBusy);
    final bool showName = context.layoutSize != LayoutSize.compact;

    if (user == null) {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.surfaceMuted,
          shape: BoxShape.circle,
        ),
      );
    }

    return MenuAnchor(
      alignmentOffset: const Offset(
        -(_menuWidth + 2 * AppSpacing.sm),
        AppSpacing.sm,
      ),
      style: const MenuStyle(
        alignment: AlignmentDirectional.bottomEnd,
        backgroundColor: WidgetStatePropertyAll<Color>(AppColors.surface),
        surfaceTintColor: WidgetStatePropertyAll<Color>(Colors.transparent),
        elevation: WidgetStatePropertyAll<double>(8),
        shadowColor: WidgetStatePropertyAll<Color>(Color(0x29101B20)),
        side: WidgetStatePropertyAll<BorderSide>(
          BorderSide(color: AppColors.line),
        ),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        ),
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.all(AppSpacing.sm),
        ),
      ),
      menuChildren: <Widget>[
        MenuItemButton(
          onPressed: () => onNavigate(HomeDestination.profile),
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.zero,
            ),
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
            ),
            overlayColor: WidgetStatePropertyAll<Color>(AppColors.surfaceMuted),
          ),
          child: _Identity(user: user, width: _menuWidth),
        ),
        const _MenuDivider(),
        _MenuItem(
          icon: Icons.manage_accounts_outlined,
          label: s.editProfile,
          onPressed: () => onNavigate(HomeDestination.profile),
        ),
        _MenuItem(
          icon: Icons.lock_reset_rounded,
          label: s.changePassword,
          onPressed: () => onNavigate(HomeDestination.changePassword),
        ),
        const _MenuDivider(),
        _MenuItem(
          icon: Icons.logout_rounded,
          label: s.logOut,
          color: AppColors.danger,
          onPressed: busy ? null : () => context.read<LogoutCubit>().logout(),
        ),
      ],
      builder:
          (BuildContext context, MenuController controller, Widget? child) =>
              Semantics(
                button: true,
                label: s.accountMenuLabel,
                child: InkWell(
                  borderRadius: AppRadius.mdAll,
                  hoverColor: AppColors.surfaceMuted,
                  onTap: busy
                      ? null
                      : () => controller.isOpen
                            ? controller.close()
                            : controller.open(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AppAvatar(name: user.name),
                        if (showName) ...<Widget>[
                          const SizedBox(width: AppSpacing.sm),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 160),
                            child: Text(
                              user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: base
                                  .merge(AppTextStyles.label)
                                  .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                            ),
                          ),
                        ],
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(
                          Icons.expand_more_rounded,
                          size: AppSizes.iconMd,
                          color: AppColors.inkSubtle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.user, required this.width});

  final UserModel user;
  final double width;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            AppAvatar(name: user.name, size: 40),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: base
                        .merge(AppTextStyles.label)
                        .copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: base
                        .merge(AppTextStyles.caption)
                        .copyWith(color: AppColors.inkSubtle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Divider(height: 1, thickness: 1, color: AppColors.line),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = AppColors.inkMuted,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    Color resolve(Set<WidgetState> states) =>
        states.contains(WidgetState.disabled) ? AppColors.inkFaint : color;

    return MenuItemButton(
      onPressed: onPressed,
      leadingIcon: Icon(icon, size: AppSizes.iconMd),
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll<Size>(
          Size(0, AppSizes.controlMedium),
        ),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
        shape: const WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(resolve),
        iconColor: WidgetStateProperty.resolveWith<Color>(resolve),
        overlayColor: const WidgetStatePropertyAll<Color>(
          AppColors.surfaceMuted,
        ),
        textStyle: WidgetStatePropertyAll<TextStyle>(
          base
              .merge(AppTextStyles.label)
              .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      child: Text(label),
    );
  }
}
