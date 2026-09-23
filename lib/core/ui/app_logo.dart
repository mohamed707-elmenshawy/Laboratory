import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_text_styles.dart';
import '../localization/localization.dart';

class AppLogoMark extends StatelessWidget {
  const AppLogoMark({
    super.key,
    this.size = 38,
    this.color = AppColors.onBrand,
    this.tileColor,
    this.tileBorderColor,
    this.logoUrl,
  });

  final double size;
  final Color color;

  final Color? tileColor;
  final Color? tileBorderColor;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final Widget glyph = _LogoGlyph(
      size: size * 0.56,
      color: color,
      url: logoUrl,
    );

    if (tileColor == null &&
        tileBorderColor == null &&
        (logoUrl == null || logoUrl!.isEmpty)) {
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
        padding: logoUrl == null || logoUrl!.isEmpty
            ? EdgeInsets.zero
            : EdgeInsets.all(size * 0.14),
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

class _LogoGlyph extends StatelessWidget {
  const _LogoGlyph({
    required this.size,
    required this.color,
    required this.url,
  });

  final double size;
  final Color color;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final Widget fallback = CustomPaint(
      size: Size.square(size),
      painter: _FlaskPainter(color: color),
    );

    final String? logoUrl = url;
    if (logoUrl == null || logoUrl.isEmpty) return fallback;

    final Uri? uri = Uri.tryParse(logoUrl);
    final bool svg = uri?.path.toLowerCase().endsWith('.svg') ?? false;

    if (kIsWeb) {
      return Image.network(
        logoUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        errorBuilder: (_, _, _) => fallback,
      );
    }

    if (svg) {
      return SvgPicture.network(
        logoUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => fallback,
        errorBuilder: (_, _, _) => fallback,
      );
    }

    return Image.network(
      logoUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => fallback,
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
    final LabSettings settings = context.labSettings;
    final String name = settings.nameFor(
      context.appLocale.code,
      fallback: productName,
    );
    final String? logoUrl = settings.logoUrl;

    final Color primary = onDark ? AppColors.onBrand : AppColors.ink;
    final Color secondary = onDark
        ? AppColors.onBrand.withValues(alpha: 0.62)
        : AppColors.inkSubtle;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Semantics(
      label: name,
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
            logoUrl: logoUrl,
          ),
          const SizedBox(width: AppSpacing.md - 1),
          ExcludeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: base
                      .merge(AppTextStyles.h3)
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
                        .merge(AppTextStyles.caption)
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
