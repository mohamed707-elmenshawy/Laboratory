import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

class AppLogoMark extends StatelessWidget {
  const AppLogoMark({
    super.key,
    this.size = 38,
    this.color = AppColors.onBrand,
    this.tileColor,
    this.tileBorderColor,
  });

  final double size;
  final Color color;

  final Color? tileColor;
  final Color? tileBorderColor;

  @override
  Widget build(BuildContext context) {
    final Widget glyph = CustomPaint(
      size: Size.square(size * 0.56),
      painter: _FlaskPainter(color: color),
    );

    if (tileColor == null && tileBorderColor == null) {
      return ExcludeSemantics(
        child: SizedBox.square(
          dimension: size,
          child: Center(child: glyph),
        ),
      );
    }

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: AppRadius.mdAll,
          border: tileBorderColor == null
              ? null
              : Border.all(color: tileBorderColor!),
        ),
        child: Center(child: glyph),
      ),
    );
  }
}

class _FlaskPainter extends CustomPainter {
  const _FlaskPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.115
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path body = Path()
      ..moveTo(w * 0.40, h * 0.10)
      ..lineTo(w * 0.40, h * 0.40)
      ..lineTo(w * 0.15, h * 0.76)
      ..quadraticBezierTo(w * 0.08, h * 0.90, w * 0.24, h * 0.90)
      ..lineTo(w * 0.76, h * 0.90)
      ..quadraticBezierTo(w * 0.92, h * 0.90, w * 0.85, h * 0.76)
      ..lineTo(w * 0.60, h * 0.40)
      ..lineTo(w * 0.60, h * 0.10);
    canvas.drawPath(body, paint);

    canvas.drawLine(
      Offset(w * 0.33, h * 0.10),
      Offset(w * 0.67, h * 0.10),
      paint,
    );

    canvas.drawLine(
      Offset(w * 0.27, h * 0.64),
      Offset(w * 0.73, h * 0.64),
      paint,
    );
  }

  @override
  bool shouldRepaint(_FlaskPainter oldDelegate) => oldDelegate.color != color;
}

class AppLogoLockup extends StatelessWidget {
  const AppLogoLockup({
    super.key,
    required this.productName,
    required this.tagline,
    this.onDark = false,
    this.markSize = 38,
    this.showTagline = true,
  });

  final String productName;
  final String tagline;
  final bool onDark;
  final double markSize;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final Color primary = onDark ? AppColors.onBrand : AppColors.ink;
    final Color secondary = onDark
        ? AppColors.onBrand.withValues(alpha: 0.62)
        : AppColors.inkSubtle;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Semantics(
      label: productName,
      image: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppLogoMark(
            size: markSize,
            color: onDark ? AppColors.onBrand : AppColors.brand600,
            tileColor: onDark
                ? AppColors.onBrand.withValues(alpha: 0.14)
                : AppColors.brandWash,
            tileBorderColor: onDark
                ? AppColors.onBrand.withValues(alpha: 0.26)
                : AppColors.brandLine,
          ),
          const SizedBox(width: AppSpacing.md - 1),
          ExcludeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  productName,
                  style: base
                      .merge(AppTypography.h3)
                      .copyWith(
                        fontSize: 16,
                        height: 1.15,
                        letterSpacing: -0.2,
                        color: primary,
                      ),
                ),
                if (showTagline) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    tagline.toUpperCase(),
                    style: base
                        .merge(AppTypography.caption)
                        .copyWith(
                          fontSize: 10.5,
                          height: 1.2,
                          letterSpacing: 1.05,
                          fontWeight: FontWeight.w400,
                          color: secondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
