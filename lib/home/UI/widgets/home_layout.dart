import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import 'home_app_bar.dart';
import 'home_destination.dart';
import 'home_sidebar.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.title,
    required this.body,
  });

  final HomeDestination selected;
  final ValueChanged<HomeDestination> onSelected;
  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final bool expanded = context.layoutSize.isExpanded;

    return Scaffold(
      backgroundColor: AppColors.ground,
      drawer: expanded
          ? null
          : Drawer(
              width: AppSizes.sidebarWidth,
              backgroundColor: AppColors.surface,
              shape: const RoundedRectangleBorder(),
              child: Builder(
                builder: (BuildContext context) => HomeSidebar(
                  selected: selected,
                  onSelected: (HomeDestination destination) {
                    Scaffold.of(context).closeDrawer();
                    onSelected(destination);
                  },
                ),
              ),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (expanded) HomeSidebar(selected: selected, onSelected: onSelected),
          Expanded(
            child: Column(
              children: <Widget>[
                HomeAppBar(
                  title: title,
                  showMenuButton: !expanded,
                  onNavigate: onSelected,
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
