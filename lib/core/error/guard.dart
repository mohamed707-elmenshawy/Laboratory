import 'app_error.dart';
import 'error_reporter.dart';
import 'result.dart';

/// Runs [body] and turns whatever it throws into a [Result].
///
/// This is the one place a repository method becomes exception-free:
/// - an [AppError] (thrown by `ApiClient`) is an expected failure, passed on;
///   if it carries a [AppError.cause], that is reported first;
/// - a [TypeError] or [FormatException] is a response that did not match the
///   model, reported and returned as [AppErrorKind.parsing];
/// - anything else is a bug, reported and returned as [AppErrorKind.unknown].
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Success<T>(await body());
  } on AppError catch (error, stackTrace) {
    if (error.cause case final Object cause) {
      ErrorReporter.report(cause, stackTrace);
    }
    return Failure<T>(error);
  } catch (error, stackTrace) {
    ErrorReporter.report(error, stackTrace);
    final bool isParsing = error is TypeError || error is FormatException;
    return Failure<T>(
      AppError(kind: isParsing ? AppErrorKind.parsing : AppErrorKind.unknown),
    );
  }
}
