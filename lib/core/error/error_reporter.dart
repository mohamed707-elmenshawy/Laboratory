import 'package:flutter/foundation.dart';

typedef ErrorReport = void Function(Object error, StackTrace stackTrace);

/// Where unexpected errors (bugs, malformed responses) are sent.
///
/// Expected failures such as "no connection" or a 422 are plain [AppError]s
/// and never reach this. The default hands the error to [FlutterError], which
/// prints on every platform (web release included) and is what Crashlytics or
/// Sentry hook through `FlutterError.onError`. Assign [report] in `main()` to
/// send somewhere else.
abstract final class ErrorReporter {
  static ErrorReport report = _reportToFlutter;

  static void _reportToFlutter(Object error, StackTrace stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'data layer',
        context: ErrorDescription('while turning a response into a Result'),
      ),
    );
  }
}
