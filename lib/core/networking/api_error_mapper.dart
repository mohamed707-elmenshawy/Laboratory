import 'package:dio/dio.dart';

import '../error/app_error.dart';

/// The user-facing part of an error response.
class ApiErrorBody {
  const ApiErrorBody({
    this.message,
    this.fieldErrors = const <String, List<String>>{},
  });

  final String? message;
  final Map<String, List<String>> fieldErrors;

  /// Reads the Laravel envelope: `message` or `meta.message` for the text,
  /// `errors` or `meta.validation_errors` for per-field messages.
  static ApiErrorBody parse(Object? data) {
    if (data is! Map) return const ApiErrorBody();

    final Object? errors = data['errors'];
    final Object? meta = data['meta'];
    final Object? metaErrors = meta is Map ? meta['validation_errors'] : null;

    final Map<String, List<String>> fields = switch ((errors, metaErrors)) {
      (final Map<dynamic, dynamic> raw, _) => _readFieldErrors(raw),
      (_, final Map<dynamic, dynamic> raw) => _readFieldErrors(raw),
      _ => const <String, List<String>>{},
    };

    final Object? topLevel = data['message'];
    if (topLevel is String && topLevel.isNotEmpty) {
      return ApiErrorBody(message: topLevel, fieldErrors: fields);
    }

    if (meta is Map) {
      final Object? metaMessage = meta['message'];
      if (metaMessage is String && metaMessage.isNotEmpty) {
        return ApiErrorBody(message: metaMessage, fieldErrors: fields);
      }
    }

    return ApiErrorBody(fieldErrors: fields);
  }

  static Map<String, List<String>> _readFieldErrors(Map<dynamic, dynamic> raw) {
    final Map<String, List<String>> result = <String, List<String>>{};

    raw.forEach((dynamic key, dynamic value) {
      if (key is! String) return;
      if (value is List) {
        final List<String> messages = value.whereType<String>().toList();
        if (messages.isNotEmpty) result[key] = messages;
      } else if (value is String && value.isNotEmpty) {
        result[key] = <String>[value];
      }
    });

    return result;
  }
}

/// Turns a [DioException] into an [AppError].
///
/// Only the body format is project-specific; pass a different [parseBody] for
/// a backend that does not answer with the Laravel envelope.
class ApiErrorMapper {
  const ApiErrorMapper({this.parseBody = ApiErrorBody.parse});

  final ApiErrorBody Function(Object? data) parseBody;

  /// Runs [send] and rethrows any [DioException] as an [AppError], keeping
  /// the original stack trace.
  Future<T> translate<T>(Future<T> Function() send) async {
    try {
      return await send();
    } on DioException catch (exception) {
      Error.throwWithStackTrace(map(exception), exception.stackTrace);
    }
  }

  AppError map(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const AppError(kind: AppErrorKind.timeout);
      case DioExceptionType.cancel:
        return const AppError(kind: AppErrorKind.cancelled);
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return const AppError(kind: AppErrorKind.network);
      case DioExceptionType.unknown:
      case DioExceptionType.badResponse:
        break;
    }

    final Response<dynamic>? response = exception.response;
    if (response == null) return _withoutResponse(exception);

    final int? status = response.statusCode;
    final ApiErrorBody body = parseBody(response.data);

    return AppError(
      kind: _kindForStatus(status),
      message: body.message,
      statusCode: status,
      fieldErrors: body.fieldErrors,
      retryAfter: _retryAfterOf(response),
    );
  }

  AppError _withoutResponse(DioException exception) {
    // Dio wraps a body it cannot decode as `unknown` with no response: a bad
    // payload, not a lost connection. The status code is lost with it, so an
    // error status whose JSON body is also malformed lands here too.
    final Object? cause = exception.error;
    if (cause is FormatException) {
      return AppError(kind: AppErrorKind.parsing, cause: cause);
    }

    return AppError(
      kind: exception.type == DioExceptionType.unknown
          ? AppErrorKind.network
          : AppErrorKind.unknown,
    );
  }

  static AppErrorKind _kindForStatus(int? status) => switch (status) {
    400 => AppErrorKind.badRequest,
    401 => AppErrorKind.unauthorized,
    403 => AppErrorKind.forbidden,
    404 => AppErrorKind.notFound,
    422 => AppErrorKind.validation,
    429 => AppErrorKind.rateLimited,
    _ when status != null && status >= 500 => AppErrorKind.server,
    _ => AppErrorKind.unknown,
  };

  static Duration? _retryAfterOf(Response<dynamic> response) {
    final String? raw = response.headers.value('retry-after');
    final int? seconds = raw == null ? null : int.tryParse(raw.trim());
    return seconds == null ? null : Duration(seconds: seconds);
  }
}
