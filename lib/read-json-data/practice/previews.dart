import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import '../models/branch.dart';
import '../models/branch_details.dart';
import '../models/inventory_item.dart';
import '../models/laboratory.dart';
import '../models/test_categories_response.dart';
import '../ui_models/inventory_item_view.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.line),
        boxShadow: AppShadows.e1,
      ),
      child: child,
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.pill,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class LaboratoryPreview extends StatelessWidget {
  const LaboratoryPreview({super.key, required this.laboratory});

  final Laboratory laboratory;

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const _IconBadge(icon: Icons.science_outlined),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(laboratory.name, style: AppTextStyles.h3)),
              StatusPill(
                label: laboratory.isActive ? 'نشط' : 'موقوف',
                color: laboratory.isActive
                    ? AppColors.success
                    : AppColors.danger,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _InfoRow(icon: Icons.phone_outlined, text: laboratory.phone),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.tag_rounded,
            text: 'رقم المعمل ${laboratory.id}',
          ),
        ],
      ),
    );
  }
}

class BranchPreview extends StatelessWidget {
  const BranchPreview({super.key, required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    final String? address = branch.address;
    final String? managerName = branch.managerName;

    return PreviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const _IconBadge(icon: Icons.store_mall_directory_outlined),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(branch.name, style: AppTextStyles.h3)),
              if (branch.isMain)
                const StatusPill(
                  label: 'الفرع الرئيسي',
                  color: AppColors.brand600,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _InfoRow(
            icon: Icons.location_on_outlined,
            text: address ?? 'مفيش عنوان مسجل',
            muted: address == null,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.person_outline_rounded,
            text: managerName ?? 'مفيش مدير متعيّن',
            muted: managerName == null,
          ),
        ],
      ),
    );
  }
}

class BranchDetailsPreview extends StatelessWidget {
  const BranchDetailsPreview({super.key, required this.branch});

  final BranchDetails branch;

  @override
  Widget build(BuildContext context) {
    final Laboratory laboratory = branch.laboratory;

    return PreviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const _IconBadge(icon: Icons.store_mall_directory_outlined),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(branch.name, style: AppTextStyles.h3)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: AppRadius.mdAll,
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.science_outlined,
                  size: AppSizes.iconMd,
                  color: AppColors.brand600,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'تبع ${laboratory.name}',
                    style: AppTextStyles.body.copyWith(color: AppColors.ink),
                  ),
                ),
                StatusPill(
                  label: laboratory.isActive ? 'نشط' : 'موقوف',
                  color: laboratory.isActive
                      ? AppColors.success
                      : AppColors.danger,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TestCategoriesPreview extends StatelessWidget {
  const TestCategoriesPreview({super.key, required this.response});

  final TestCategoriesResponse response;

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const _IconBadge(icon: Icons.category_outlined),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Text('أقسام التحاليل', style: AppTextStyles.h3),
              ),
              Flexible(
                child: Text(
                  'رسالة السيرفر: ${response.message}',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (response.categories.isEmpty)
            Text(
              'القايمة فاضية',
              style: AppTextStyles.body.copyWith(color: AppColors.inkFaint),
            ),
          for (int index = 0; index < response.categories.length; index++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                border: index == 0
                    ? null
                    : const Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      response.categories[index].name,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                  StatusPill(
                    label: '${response.categories[index].testsCount} تحليل',
                    color: AppColors.brand600,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class InventoryRawPreview extends StatelessWidget {
  const InventoryRawPreview({super.key, required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text('البيانات جوه الموديل', style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'ده شكلها بعد التحويل. لسه مش جاهزة تتعرض للمستخدم، والمستوى 6 هيظبطها.',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.lg),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: <Widget>[
                _RawLine(field: 'name', value: item.name),
                _RawLine(field: 'quantity', value: '${item.quantity}'),
                _RawLine(field: 'price', value: _doubleText(item.price)),
                _RawLine(field: 'status', value: '${item.status}'),
                _RawLine(field: 'expiresAt', value: '${item.expiresAt}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryCardPreview extends StatelessWidget {
  const InventoryCardPreview({super.key, required this.view});

  final InventoryItemView view;

  @override
  Widget build(BuildContext context) {
    return PreviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const _IconBadge(icon: Icons.inventory_2_outlined),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(view.title, style: AppTextStyles.h3)),
              StatusPill(label: view.statusLabel, color: view.statusColor),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.x3l,
            runSpacing: AppSpacing.md,
            children: <Widget>[
              _Metric(label: 'السعر', value: view.priceText),
              _Metric(label: 'الكمية', value: view.quantityText),
              _Metric(label: 'ينتهي في', value: view.expiryText),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.controlMedium,
      height: AppSizes.controlMedium,
      decoration: const BoxDecoration(
        color: AppColors.brandWash,
        borderRadius: AppRadius.mdAll,
      ),
      child: Icon(icon, size: AppSizes.iconLg, color: AppColors.brand600),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text, this.muted = false});

  final IconData icon;
  final String text;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: AppSizes.iconMd, color: AppColors.inkSubtle),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              color: muted ? AppColors.inkFaint : AppColors.inkMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class _RawLine extends StatelessWidget {
  const _RawLine({required this.field, required this.value});

  final String field;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 96, child: Text(field, style: AppTextStyles.caption)),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

String _doubleText(double value) {
  final String text = '$value';
  return text.contains('.') || text.contains('e') ? text : '$text.0';
}
