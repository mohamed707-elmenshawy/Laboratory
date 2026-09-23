import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../data/models/laboratories_query.dart';
import '../../logic/laboratories_cubit.dart';

class LaboratoriesToolbar extends StatelessWidget {
  const LaboratoriesToolbar({super.key});

  static const double _stackFrom = 640;
  static const double _searchMaxWidth = 380;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.line,
            width: AppSizes.borderWidth,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < _stackFrom) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LaboratoriesSearchField(),
                SizedBox(height: AppSpacing.md),
                LaboratoriesStatusFilter(expand: true),
              ],
            );
          }

          return Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _searchMaxWidth,
                    ),
                    child: const LaboratoriesSearchField(),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              const LaboratoriesStatusFilter(),
            ],
          );
        },
      ),
    );
  }
}

class LaboratoriesSearchField extends StatefulWidget {
  const LaboratoriesSearchField({super.key});

  static const Duration debounce = Duration(milliseconds: 400);

  @override
  State<LaboratoriesSearchField> createState() =>
      _LaboratoriesSearchFieldState();
}

class _LaboratoriesSearchFieldState extends State<LaboratoriesSearchField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  bool _hovered = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<LaboratoriesCubit>().search,
    );
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus != _focused) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  void _onChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(LaboratoriesSearchField.debounce, _apply);
  }

  void _apply() {
    _debounce?.cancel();
    context.read<LaboratoriesCubit>().changeSearch(_controller.text);
  }

  void _clear() {
    _controller.clear();
    setState(() {});
    _apply();
    _focusNode.requestFocus();
  }

  // Filters can also be cleared from outside the field (the empty state's
  // "Clear filters"), so pull the cubit's term back in when it drifts.
  void _syncFromCubit(BuildContext context, LaboratoriesState _) {
    if (_debounce?.isActive ?? false) return;
    final String search = context.read<LaboratoriesCubit>().search;
    if (_controller.text.trim() != search) {
      _controller.text = search;
      setState(() {});
    }
  }

  Color get _borderColor {
    if (_focused) return AppColors.brand600;
    if (_hovered) return AppColors.lineStrong;
    return AppColors.line;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final TextStyle valueStyle = base
        .merge(AppTextStyles.body)
        .copyWith(fontSize: 14, color: AppColors.ink);
    final bool hasText = _controller.text.isNotEmpty;

    return BlocListener<LaboratoriesCubit, LaboratoriesState>(
      listener: _syncFromCubit,
      child: MouseRegion(
        cursor: SystemMouseCursors.text,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: AppMotion.resolve(context, AppMotion.fast),
          curve: AppMotion.curve,
          height: AppSizes.controlMedium,
          padding: const EdgeInsetsDirectional.only(
            start: AppSpacing.md,
            end: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: _borderColor,
              width: AppSizes.borderWidth,
            ),
            boxShadow: _focused
                ? AppShadows.focusRing(AppColors.focusRing)
                : AppShadows.none,
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.search_rounded,
                size: AppSizes.iconMd,
                color: _focused ? AppColors.inkSubtle : AppColors.inkFaint,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Semantics(
                  label: s.laboratoriesSearchHint,
                  textField: true,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _onChanged,
                    onSubmitted: (_) => _apply(),
                    textInputAction: TextInputAction.search,
                    maxLength: 100,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    style: valueStyle,
                    cursorColor: AppColors.brand600,
                    cursorWidth: 1.5,
                    cursorRadius: const Radius.circular(1),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterText: '',
                      hintText: s.laboratoriesSearchHint,
                      hintStyle: valueStyle.copyWith(color: AppColors.inkFaint),
                    ),
                  ),
                ),
              ),
              if (hasText)
                IconButton(
                  onPressed: _clear,
                  tooltip: s.clearSearch,
                  iconSize: AppSizes.iconMd,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: AppSizes.controlSmall,
                    height: AppSizes.controlSmall,
                  ),
                  hoverColor: AppColors.brandWash,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.inkSubtle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LaboratoriesStatusFilter extends StatelessWidget {
  const LaboratoriesStatusFilter({super.key, this.expand = false});

  final bool expand;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final LaboratoriesCubit cubit = context.read<LaboratoriesCubit>();
    final LaboratoryStatusFilter selected = context.select(
      (LaboratoriesCubit cubit) => cubit.status,
    );

    final List<Widget> segments = <Widget>[
      for (final LaboratoryStatusFilter status in LaboratoryStatusFilter.values)
        _Segment(
          label: switch (status) {
            LaboratoryStatusFilter.all => s.statusFilterAll,
            LaboratoryStatusFilter.active => s.statusActive,
            LaboratoryStatusFilter.inactive => s.statusInactive,
          },
          dotColor: switch (status) {
            LaboratoryStatusFilter.all => null,
            LaboratoryStatusFilter.active => AppColors.success,
            LaboratoryStatusFilter.inactive => AppColors.inkFaint,
          },
          isSelected: status == selected,
          onPressed: () => cubit.changeStatus(status),
        ),
    ];

    return Semantics(
      container: true,
      label: s.statusFilterLabel,
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
            for (final Widget segment in segments)
              expand ? Expanded(child: segment) : segment,
          ],
        ),
      ),
    );
  }
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
