import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/logout_cubit.dart';
import 'home_user_menu.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.title,
    required this.showMenuButton,
  });

  final String title;
  final bool showMenuButton;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool busy = context.select((LogoutCubit cubit) => cubit.isBusy);

    return Container(
      height: AppSizes.appBarHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: <Widget>[
                if (showMenuButton) ...<Widget>[
                  IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    color: AppColors.inkMuted,
                    tooltip: s.openNavigation,
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: base
                        .merge(AppTextStyles.h3)
                        .copyWith(color: AppColors.ink),
                  ),
                ),
                AppLanguageSwitcher(
                  value: context.appLocale,
                  onChanged: context.setAppLocale,
                  semanticLabel: s.languageSwitcherLabel,
                  enabled: !busy,
                ),
                const SizedBox(width: AppSpacing.md),
                const HomeUserMenu(),
              ],
            ),
          ),
          if (busy)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LinearProgressIndicator(
                minHeight: 2,
                color: AppColors.brand600,
                backgroundColor: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }
}
