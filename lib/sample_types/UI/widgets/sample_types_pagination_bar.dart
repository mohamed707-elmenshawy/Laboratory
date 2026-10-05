import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../data/models/sample_types_page.dart';
import '../../logic/sample_types_cubit.dart';

class SampleTypesPaginationBar extends StatelessWidget {
  const SampleTypesPaginationBar({super.key, required this.pagination});

  static const double _stackFrom = 640;

  final SampleTypesPagination pagination;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    final int from = pagination.from ?? 0;
    final int to = pagination.to ?? 0;

    final Widget summary = Text(
      pagination.total == 0
          ? s.noResults
          : s.showingResults(from, to, pagination.total),
      style: base
          .merge(AppTextStyles.caption)
          .copyWith(fontSize: 12.5, color: AppColors.inkSubtle),
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.line, width: AppSizes.borderWidth),
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < _stackFrom) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                summary,
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.lg,
                    runSpacing: AppSpacing.md,
                    children: <Widget>[
                      const _PerPageSelector(),
                      _PageControls(
                        pagination: pagination,
                        window: _PageControls.compactWindow,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Row(
            children: <Widget>[
              Expanded(child: summary),
              const _PerPageSelector(),
              const SizedBox(width: AppSpacing.lg),
              _PageControls(pagination: pagination),
            ],
          );
        },
      ),
    );
  }
}

class _PerPageSelector extends StatelessWidget {
  const _PerPageSelector();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final SampleTypesCubit cubit = context.read<SampleTypesCubit>();
    final bool enabled = context.select(
      (SampleTypesCubit cubit) => !cubit.isBusy,
    );

    final TextStyle itemStyle = base
        .merge(AppTextStyles.body)
        .copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: enabled ? AppColors.ink : AppColors.inkFaint,
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          s.perPage,
          style: base
              .merge(AppTextStyles.caption)
              .copyWith(fontSize: 12.5, color: AppColors.inkSubtle),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          height: AppSizes.controlSmall,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: AppColors.line,
              width: AppSizes.borderWidth,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: cubit.perPage,
              isDense: true,
              borderRadius: AppRadius.mdAll,
              focusColor: const Color(0x00000000),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: AppSizes.iconMd,
                color: AppColors.inkSubtle,
              ),
              style: itemStyle,
              items: SampleTypesCubit.perPageOptions
                  .map(
                    (int size) => DropdownMenuItem<int>(
                      value: size,
                      child: Text('$size', style: itemStyle),
                    ),
                  )
                  .toList(growable: false),
              onChanged: enabled
                  ? (int? size) {
                      if (size != null) cubit.changePerPage(size);
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _PageControls extends StatelessWidget {
  const _PageControls({required this.pagination, this.window = 5});

  static const int compactWindow = 3;

  final SampleTypesPagination pagination;
  final int window;

  List<int> get _pages {
    final int last = pagination.lastPage;
    if (last <= window) {
      return <int>[for (int page = 1; page <= last; page++) page];
    }

    int start = pagination.currentPage - window ~/ 2;
    if (start < 1) start = 1;
    if (start + window - 1 > last) start = last - window + 1;

    return <int>[for (int i = 0; i < window; i++) start + i];
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final SampleTypesCubit cubit = context.read<SampleTypesCubit>();
    final bool enabled = context.select(
      (SampleTypesCubit cubit) => !cubit.isBusy,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _PageArrow(
          icon: Icons.chevron_left_rounded,
          tooltip: s.previousPage,
          onPressed: enabled && pagination.hasPrevious
              ? () => cubit.goToPage(pagination.currentPage - 1)
              : null,
        ),
        for (final int page in _pages)
          _PageButton(
            page: page,
            isCurrent: page == pagination.currentPage,
            onPressed: enabled && page != pagination.currentPage
                ? () => cubit.goToPage(page)
                : null,
          ),
        _PageArrow(
          icon: Icons.chevron_right_rounded,
          tooltip: s.nextPage,
          onPressed: enabled && pagination.hasNext
              ? () => cubit.goToPage(pagination.currentPage + 1)
              : null,
        ),
      ],
    );
  }
}

class _PageArrow extends StatelessWidget {
  const _PageArrow({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: AppSizes.iconLg,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: AppSizes.hitTarget,
        height: AppSizes.hitTarget,
      ),
      hoverColor: AppColors.brandWash,
      disabledColor: AppColors.inkFaint,
      icon: Icon(icon, color: AppColors.inkMuted),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.page,
    required this.isCurrent,
    required this.onPressed,
  });

  final int page;
  final bool isCurrent;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Semantics(
        button: true,
        selected: isCurrent,
        label: s.pageNumber(page),
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.mdAll,
          hoverColor: AppColors.brandWash,
          child: Container(
            constraints: const BoxConstraints.tightFor(
              width: AppSizes.hitTarget,
              height: AppSizes.hitTarget,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isCurrent ? AppColors.brand600 : AppColors.surface,
              borderRadius: AppRadius.mdAll,
              border: Border.all(
                color: isCurrent ? AppColors.brand600 : AppColors.line,
                width: AppSizes.borderWidth,
              ),
            ),
            child: Text(
              '$page',
              style: base
                  .merge(AppTextStyles.caption)
                  .copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isCurrent ? AppColors.onBrand : AppColors.inkMuted,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
