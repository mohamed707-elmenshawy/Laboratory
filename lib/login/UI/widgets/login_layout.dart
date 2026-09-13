import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key, this.brandPanel, required this.formPane});

  final Widget? brandPanel;

  final Widget formPane;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final LayoutSize size = AppBreakpoints.of(constraints.maxWidth);

        return switch (size) {
          LayoutSize.expanded => _buildExpanded(constraints.maxWidth),
          LayoutSize.medium => _buildMedium(),
          LayoutSize.compact => _buildCompact(),
        };
      },
    );
  }

  Widget get _form => Align(
    alignment: AlignmentDirectional.topCenter,
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.formColumnWidth),
      child: formPane,
    ),
  );

  Widget _buildExpanded(double width) {
    final double panelWidth = (width * AppSizes.brandPanelFlex).clamp(
      AppSizes.brandPanelMinWidth,
      AppSizes.brandPanelMaxWidth,
    );

    return ColoredBox(
      color: AppColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (brandPanel != null)
            SizedBox(width: panelWidth, child: brandPanel),
          Expanded(
            child: _ScrollableCentre(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4l,
                vertical: AppSpacing.x5l,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.formColumnWidth,
                ),
                child: _form,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedium() {
    return ColoredBox(
      color: AppColors.ground,
      child: _ScrollableCentre(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4l),
        child: Container(
          width: AppSizes.authCardWidth,
          padding: const EdgeInsets.all(AppSpacing.x3l),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.lgAll,
            boxShadow: AppShadows.e1,
          ),
          child: _form,
        ),
      ),
    );
  }

  Widget _buildCompact() {
    return ColoredBox(
      color: AppColors.surface,
      child: _ScrollableCentre(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.x5l,
        ),
        child: SizedBox(width: double.infinity, child: _form),
      ),
    );
  }
}

class _ScrollableCentre extends StatelessWidget {
  const _ScrollableCentre({required this.padding, required this.child});

  final EdgeInsetsGeometry padding;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double minHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : 0;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Center(
              child: Padding(padding: padding, child: child),
            ),
          ),
        );
      },
    );
  }
}
