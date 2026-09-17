import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import '../server/fake_api.dart';
import 'practice_engine.dart';

class PracticeHeader extends StatelessWidget {
  const PracticeHeader({
    super.key,
    required this.doneCount,
    required this.totalCount,
    required this.onReload,
  });

  final int doneCount;
  final int totalCount;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    final bool finished = doneCount == totalCount;

    return Wrap(
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.lg,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('تمرين قراءة الـ JSON', style: AppTextStyles.display),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'كل مستوى فيه رد جاي من سيرفر وهمي. اكتب الكود اللي بيحوّله لموديل، والشاشة هتعرضه في التصميم وتراجعه لك.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: finished ? AppColors.successWash : AppColors.brandWash,
                borderRadius: AppRadius.pill,
                border: Border.all(
                  color: finished ? AppColors.successLine : AppColors.brandLine,
                ),
              ),
              child: Text(
                'خلصت $doneCount من $totalCount',
                style: AppTextStyles.label.copyWith(
                  color: finished ? AppColors.success : AppColors.brand700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            TextButton.icon(
              onPressed: onReload,
              icon: const Icon(Icons.refresh_rounded, size: AppSizes.iconMd),
              label: const Text('هات البيانات تاني'),
            ),
          ],
        ),
      ],
    );
  }
}

class LevelTabs extends StatelessWidget {
  const LevelTabs({
    super.key,
    required this.reports,
    required this.selectedLevel,
    required this.onSelected,
  });

  final List<LevelReport> reports;
  final int selectedLevel;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        for (final LevelReport report in reports)
          _LevelChip(
            number: report.level.number,
            status: report.status,
            selected: report.level.number == selectedLevel,
            onTap: () => onSelected(report.level.number),
          ),
      ],
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.number,
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final int number;
  final LevelStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (status) {
      LevelStatus.done => (Icons.check_circle_rounded, AppColors.success),
      LevelStatus.failing => (Icons.error_rounded, AppColors.danger),
      LevelStatus.blocked => (Icons.lock_outline_rounded, AppColors.inkFaint),
      LevelStatus.notStarted => (
        Icons.radio_button_unchecked_rounded,
        AppColors.inkSubtle,
      ),
    };

    return Material(
      color: selected ? AppColors.brandWash : AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? AppColors.brand600 : AppColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: AppSizes.iconMd, color: color),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'المستوى $number',
                style: AppTextStyles.label.copyWith(
                  color: selected ? AppColors.brand800 : AppColors.inkMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelPanel extends StatelessWidget {
  const LevelPanel({super.key, required this.report});

  final LevelReport report;

  @override
  Widget build(BuildContext context) {
    final PracticeLevel level = report.level;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'المستوى ${level.number}: ${level.title}',
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          level.goal,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.inkMuted),
        ),
        const SizedBox(height: AppSpacing.lg),
        _FilesBox(files: level.files),
        if (report.status == LevelStatus.done) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          const _DoneBanner(),
        ],
        for (int index = 0; index < level.samples.length; index++) ...<Widget>[
          const SizedBox(height: AppSpacing.x3l),
          _SampleSection(
            title: level.samples.length > 1 ? 'العينة ${index + 1}' : null,
            path: level.samples[index].path,
            outcome: report.outcomes[index],
          ),
        ],
      ],
    );
  }
}

class _FilesBox extends StatelessWidget {
  const _FilesBox({required this.files});

  final List<String> files;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.mdAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            files.length > 1
                ? 'الملفات اللي هتكتب فيها'
                : 'الملف اللي هتكتب فيه',
            style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w600),
          ),
          for (final String file in files) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            SelectableText(
              file,
              textDirection: TextDirection.ltr,
              style: AppTextStyles.body.copyWith(
                color: AppColors.brand800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DoneBanner extends StatelessWidget {
  const _DoneBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.successWash,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.successLine),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.celebration_rounded,
            size: AppSizes.iconLg,
            color: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'برافو! المستوى ده خلص وكل المراجعات صح. كمّل على اللي بعده.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SampleSection extends StatelessWidget {
  const _SampleSection({
    required this.title,
    required this.path,
    required this.outcome,
  });

  final String? title;
  final String path;
  final SampleOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final String? title = this.title;
    final Widget source = _Side(
      label: 'اللي جاي من السيرفر',
      child: JsonBlock(path: path),
    );
    final Widget result = _Side(
      label: 'اللي طلع في التصميم',
      child: OutcomeView(outcome: outcome),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (title != null) ...<Widget>[
              Text(title, style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.md),
            ],
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: source),
                  const SizedBox(width: AppSpacing.xxl),
                  Expanded(child: result),
                ],
              )
            else ...<Widget>[
              source,
              const SizedBox(height: AppSpacing.xl),
              result,
            ],
          ],
        );
      },
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.inkSubtle,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}

class JsonBlock extends StatelessWidget {
  const JsonBlock({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.brand900,
        borderRadius: AppRadius.lgAll,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'GET $path',
              style: AppTextStyles.label.copyWith(
                color: AppColors.brandLine,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SelectableText(
              FakeApi.rawBody(path),
              style: AppTextStyles.body.copyWith(
                color: AppColors.onBrand,
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutcomeView extends StatelessWidget {
  const OutcomeView({super.key, required this.outcome});

  final SampleOutcome outcome;

  @override
  Widget build(BuildContext context) {
    return switch (outcome) {
      SampleNotStarted() => const _StateBox(
        icon: Icons.edit_note_rounded,
        color: AppColors.brand600,
        background: AppColors.brandWash,
        border: AppColors.brandLine,
        title: 'لسه متحلش',
        message:
            'في ملف من الملفات اللي فوق لسه فيه السطر ده. امسحه واكتب الكود مكانه، وبعدها احفظ واضغط r في التيرمنال.',
        code: 'throw UnimplementedError();',
      ),
      SampleBlocked(:final int requiredLevel) => _StateBox(
        icon: Icons.lock_outline_rounded,
        color: AppColors.inkSubtle,
        background: AppColors.surfaceMuted,
        border: AppColors.line,
        title: 'مقفول لسه',
        message:
            'المستوى ده بيستخدم الموديل بتاع المستوى $requiredLevel. خلّصه الأول وارجع هنا.',
      ),
      SampleCrashed(:final Object error) => _StateBox(
        icon: Icons.error_outline_rounded,
        color: AppColors.danger,
        background: AppColors.dangerWash,
        border: AppColors.dangerLine,
        title: 'الكود وقع وهو بيقرا الـ JSON',
        message:
            'اقرا الرسالة دي كويس. غالباً هتلاقي فيها النوع اللي جه من السيرفر، والنوع اللي انت كتبته.',
        code: '$error',
      ),
      SampleParsed(:final Widget preview, :final List<PracticeCheck> checks) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            preview,
            const SizedBox(height: AppSpacing.lg),
            ChecksList(checks: checks),
          ],
        ),
    };
  }
}

class _StateBox extends StatelessWidget {
  const _StateBox({
    required this.icon,
    required this.color,
    required this.background,
    required this.border,
    required this.title,
    required this.message,
    this.code,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final Color border;
  final String title;
  final String message;
  final String? code;

  @override
  Widget build(BuildContext context) {
    final String? code = this.code;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: AppSizes.iconLg, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(color: color, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTextStyles.body),
          if (code != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.smAll,
                border: Border.all(color: border),
              ),
              child: SelectableText(
                code,
                textDirection: TextDirection.ltr,
                style: AppTextStyles.body.copyWith(color: AppColors.ink),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChecksList extends StatelessWidget {
  const ChecksList({super.key, required this.checks});

  final List<PracticeCheck> checks;

  @override
  Widget build(BuildContext context) {
    final int passedCount = checks
        .where((PracticeCheck check) => check.passed)
        .length;
    final bool allPassed = passedCount == checks.length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'المراجعة',
                  style: AppTextStyles.h3.copyWith(fontSize: 16),
                ),
              ),
              Text(
                '$passedCount من ${checks.length} صح',
                style: AppTextStyles.label.copyWith(
                  color: allPassed ? AppColors.success : AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final PracticeCheck check in checks) _CheckRow(check: check),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.check});

  final PracticeCheck check;

  @override
  Widget build(BuildContext context) {
    final bool passed = check.passed;
    final TextDirection valueDirection =
        check.expected is String || check.actual is String
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: AppSizes.iconMd,
              color: passed ? AppColors.success : AppColors.danger,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  check.field,
                  textDirection: TextDirection.ltr,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!passed) ...<Widget>[
                  _ValueLine(
                    label: 'المتوقع',
                    value: describeValue(check.expected),
                    direction: valueDirection,
                    color: AppColors.success,
                  ),
                  _ValueLine(
                    label: 'اللي طلع',
                    value: describeValue(check.actual),
                    direction: valueDirection,
                    color: AppColors.danger,
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

class _ValueLine extends StatelessWidget {
  const _ValueLine({
    required this.label,
    required this.value,
    required this.direction,
    required this.color,
  });

  final String label;
  final String value;
  final TextDirection direction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 64, child: Text(label, style: AppTextStyles.caption)),
          Flexible(
            child: Text(
              value,
              textDirection: direction,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'بنجيب البيانات من السيرفر الوهمي...',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}

class LoadErrorView extends StatelessWidget {
  const LoadErrorView({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.cloud_off_rounded,
              size: 40,
              color: AppColors.danger,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('مقدرناش نجيب البيانات', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.sm),
            SelectableText(
              '$error',
              textDirection: TextDirection.ltr,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('جرّب تاني')),
          ],
        ),
      ),
    );
  }
}

String describeValue(Object? value) {
  return switch (value) {
    null => 'null',
    final String text => "'$text'",
    final Color color => _colorNames[color] ?? _hex(color),
    final DateTime date => date.toIso8601String(),
    _ => '$value',
  };
}

final Map<Color, String> _colorNames = <Color, String>{
  AppColors.success: 'AppColors.success',
  AppColors.warning: 'AppColors.warning',
  AppColors.danger: 'AppColors.danger',
  AppColors.inkSubtle: 'AppColors.inkSubtle',
  AppColors.brand600: 'AppColors.brand600',
};

String _hex(Color color) {
  final String hex = color
      .toARGB32()
      .toRadixString(16)
      .padLeft(8, '0')
      .toUpperCase();
  return '#$hex';
}
