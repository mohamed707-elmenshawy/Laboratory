import 'package:flutter/material.dart';

import '../design_system/design_system.dart';

class AppSegment<T> {
  const AppSegment({required this.value, required this.label, this.dotColor});

  final T value;
  final String label;
  final Color? dotColor;
}

class AppSegmentedFilter<T> extends StatelessWidget {
  const AppSegmentedFilter({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    this.expand = false,
  });

  final List<AppSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;
  final String semanticLabel;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: Container(
        height: AppSizes.controlMedium,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: AppColors.line,
            width: AppSizes.borderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          children: <Widget>[
            for (final AppSegment<T> segment in segments)
              if (expand)
                Expanded(child: _buildSegment(segment))
              else
                _buildSegment(segment),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment(AppSegment<T> segment) => _Segment(
    label: segment.label,
    dotColor: segment.dotColor,
    isSelected: segment.value == value,
    onPressed: () => onChanged(segment.value),
  );
}

class _Segment extends StatefulWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.dotColor,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color? dotColor;

  @override
  State<_Segment> createState() => _SegmentState();
}

class _SegmentState extends State<_Segment> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool selected = widget.isSelected;

    return Semantics(
      button: true,
      selected: selected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: selected ? null : widget.onPressed,
          child: AnimatedContainer(
            duration: AppMotion.resolve(context, AppMotion.fast),
            curve: AppMotion.curve,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.surface
                  : _hovered
                  ? AppColors.surfaceSunken
                  : const Color(0x00000000),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.md - 3),
              ),
              boxShadow: selected
                  ? const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x14101B20),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ]
                  : AppShadows.none,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.dotColor != null) ...<Widget>[
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: widget.dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs + 2),
                ],
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: base
                        .merge(AppTextStyles.caption)
                        .copyWith(
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: selected ? AppColors.ink : AppColors.inkSubtle,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
