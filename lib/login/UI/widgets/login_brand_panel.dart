import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';

class LoginBrandPanel extends StatelessWidget {
  const LoginBrandPanel({super.key});

  static const double _measure = 340;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final List<String> capabilities = s.brandCapabilities;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(gradient: AppColors.brandPanel),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _GridPainter())),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x4l + 4,
                        vertical: AppSpacing.x4l,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AppLogoLockup(
                            productName: s.productName,
                            tagline: s.productTagline,
                            onDark: true,
                            markSize: 38,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: _measure,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  s.brandStatement,
                                  style: base
                                      .merge(AppTypography.h2)
                                      .copyWith(
                                        fontSize: 28,
                                        height: 1.26,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.45,
                                        color: AppColors.onBrandPanel,
                                      ),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                Text(
                                  s.brandStatementSupport,
                                  style: base
                                      .merge(AppTypography.body)
                                      .copyWith(
                                        fontSize: 13.5,
                                        height: 1.62,
                                        color: AppColors.onBrandPanel
                                            .withValues(alpha: 0.72),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: _measure,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                for (
                                  int i = 0;
                                  i < capabilities.length;
                                  i++
                                ) ...<Widget>[
                                  if (i > 0)
                                    const SizedBox(height: AppSpacing.md - 1),
                                  _CapabilityLine(label: capabilities[i]),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CapabilityLine extends StatelessWidget {
  const _CapabilityLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 6),
          child: SizedBox(
            width: 5,
            height: 5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.onBrandPanel.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(1.5)),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Flexible(
          child: Text(
            label,
            style: base
                .merge(AppTypography.body)
                .copyWith(
                  fontSize: 12.5,
                  height: 1.5,
                  color: AppColors.onBrandPanel.withValues(alpha: 0.8),
                ),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  static const double _cell = 34;

  static const Color _line = Color(0x21FFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = _line
      ..strokeWidth = 1
      ..isAntiAlias = false;

    for (double x = _cell; x < size.width; x += _cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = _cell; y < size.height; y += _cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}
