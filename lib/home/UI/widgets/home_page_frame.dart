import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

class HomePageFrame extends StatelessWidget {
  const HomePageFrame({
    super.key,
    required this.child,
    this.maxWidth = AppSizes.contentMaxWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.x3l),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
