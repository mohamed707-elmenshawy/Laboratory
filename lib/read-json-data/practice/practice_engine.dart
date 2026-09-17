import 'package:flutter/widgets.dart';

class PracticeCheck {
  const PracticeCheck(
    this.field, {
    required this.expected,
    required this.actual,
  });

  final String field;
  final Object? expected;
  final Object? actual;

  bool get passed => expected == actual;
}

sealed class SampleOutcome {
  const SampleOutcome();
}

final class SampleNotStarted extends SampleOutcome {
  const SampleNotStarted();
}

final class SampleBlocked extends SampleOutcome {
  const SampleBlocked(this.requiredLevel);

  final int requiredLevel;
}

final class SampleCrashed extends SampleOutcome {
  const SampleCrashed(this.error);

  final Object error;
}

final class SampleParsed extends SampleOutcome {
  const SampleParsed({required this.preview, required this.checks});

  final Widget preview;
  final List<PracticeCheck> checks;

  bool get passed => checks.every((PracticeCheck check) => check.passed);
}

class PracticeSample {
  const PracticeSample({required this.path, required this.run});

  final String path;
  final SampleOutcome Function(dynamic body) run;
}

class PracticeLevel {
  const PracticeLevel({
    required this.number,
    required this.title,
    required this.goal,
    required this.files,
    required this.samples,
    this.requiredLevel,
  });

  final int number;
  final String title;
  final String goal;
  final List<String> files;
  final List<PracticeSample> samples;
  final int? requiredLevel;
}

enum LevelStatus { notStarted, blocked, failing, done }

class LevelReport {
  const LevelReport({required this.level, required this.outcomes});

  final PracticeLevel level;
  final List<SampleOutcome> outcomes;

  LevelStatus get status {
    if (outcomes.any((SampleOutcome outcome) => outcome is SampleBlocked)) {
      return LevelStatus.blocked;
    }

    final bool failing = outcomes.any(
      (SampleOutcome outcome) => switch (outcome) {
        SampleCrashed() => true,
        SampleParsed(:final bool passed) => !passed,
        _ => false,
      },
    );
    if (failing) {
      return LevelStatus.failing;
    }

    if (outcomes.every((SampleOutcome outcome) => outcome is SampleParsed)) {
      return LevelStatus.done;
    }

    return LevelStatus.notStarted;
  }
}

List<LevelReport> evaluateLevels(
  List<PracticeLevel> levels,
  Map<String, dynamic> bodies,
) {
  final Map<int, LevelStatus> statuses = <int, LevelStatus>{};
  final List<LevelReport> reports = <LevelReport>[];

  for (final PracticeLevel level in levels) {
    final int? requiredLevel = level.requiredLevel;
    final LevelReport report;

    if (requiredLevel != null && statuses[requiredLevel] != LevelStatus.done) {
      report = LevelReport(
        level: level,
        outcomes: <SampleOutcome>[
          for (final PracticeSample _ in level.samples)
            SampleBlocked(requiredLevel),
        ],
      );
    } else {
      report = LevelReport(
        level: level,
        outcomes: <SampleOutcome>[
          for (final PracticeSample sample in level.samples)
            _attempt(sample, bodies[sample.path]),
        ],
      );
    }

    statuses[level.number] = report.status;
    reports.add(report);
  }

  return reports;
}

SampleOutcome _attempt(PracticeSample sample, dynamic body) {
  try {
    return sample.run(body);
  } on UnimplementedError {
    return const SampleNotStarted();
  } catch (error) {
    return SampleCrashed(error);
  }
}
