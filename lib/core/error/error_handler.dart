import '../networking/api_error_mapper.dart';
import 'guard.dart' as policy;
import 'result.dart';

/// Entry point for repositories that still take a raw `Dio`.
///
/// New code takes an `ApiClient` and calls the top-level `guard`. Once the
/// last repository has moved, delete this class. It follows the same policy
/// as `guard`, so a body that cannot be parsed is reported and returned as
/// `AppErrorKind.parsing`.
class ErrorHandler {
  ErrorHandler._();

  static const ApiErrorMapper _mapper = ApiErrorMapper();

  static Future<Result<T>> guard<T>(Future<T> Function() action) =>
      policy.guard(() => _mapper.translate(action));
}
