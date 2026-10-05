import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/error/error_reporter.dart';

typedef Report = ({Object error, StackTrace stackTrace});

/// Collects what [ErrorReporter] receives, for each test in the calling
/// scope, and puts the real hook back afterwards.
List<Report> captureReports() {
  final List<Report> reports = <Report>[];
  late ErrorReport original;

  setUp(() {
    reports.clear();
    original = ErrorReporter.report;
    ErrorReporter.report = (Object error, StackTrace stackTrace) =>
        reports.add((error: error, stackTrace: stackTrace));
  });

  tearDown(() => ErrorReporter.report = original);

  return reports;
}
