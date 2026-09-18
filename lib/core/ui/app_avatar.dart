import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_text_styles.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.name, this.size = 32});

  final String name;
  final double size;

  String get _initials {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.brandWash,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.brandLine),
      ),
      child: Text(
        _initials,
        maxLines: 1,
        style: base
            .merge(AppTextStyles.label)
            .copyWith(
              fontSize: size * 0.38,
              fontWeight: FontWeight.w600,
              color: AppColors.brand700,
              height: 1,
            ),
      ),
    );
  }
}
