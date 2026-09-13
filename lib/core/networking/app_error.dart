import 'package:dio/dio.dart';

enum AppErrorKind {
  network,

  timeout,

  cancelled,

  badRequest,

  unauthorized,

  forbidden,

  notFound,

  validation,

  rateLimited,

  server,

  unknown,
}

class AppError implements Exception {
  const AppError({
    required this.kind,
    this.message,
    this.statusCode,
    this.fieldErrors = const <String, List<String>>{},
    this.retryAfter,
  });

  final AppErrorKind kind;

  final String? message;

  final int? statusCode;

  final Map<String, List<String>> fieldErrors;

  final Duration? retryAfter;

  factory AppError.from(Object error) {
    if (error is AppError) return error;
    if (error is DioException) return AppError._fromDio(error);
    return const AppError(kind: AppErrorKind.unknown);
  }

  factory AppError._fromDio(DioException exception) {
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
        if (exception.response == null) {
          return const AppError(kind: AppErrorKind.network);
        }
      case DioExceptionType.badResponse:
        break;
    }

    final Response<dynamic>? response = exception.response;
    if (response == null) return const AppError(kind: AppErrorKind.unknown);

    final int? status = response.statusCode;
    final _Body body = _Body.parse(response.data);

    return AppError(
      kind: _kindForStatus(status),
      message: body.message,
      statusCode: status,
      fieldErrors: body.fieldErrors,
      retryAfter: _retryAfterOf(response),
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

  String? fieldError(String field) {
    final List<String>? messages = fieldErrors[field];
    return (messages == null || messages.isEmpty) ? null : messages.first;
  }

  bool get hasFieldErrors => fieldErrors.isNotEmpty;

  @override
  String toString() =>
      'AppError(${kind.name}, status: $statusCode, message: $message)';
}

class _Body {
  const _Body({
    this.message,
    this.fieldErrors = const <String, List<String>>{},
  });

  final String? message;
  final Map<String, List<String>> fieldErrors;

  static _Body parse(dynamic data) {
    if (data is! Map) return const _Body();

    final Object? errors = data['errors'];
    final Map<String, List<String>> fields = errors is Map
        ? _readFieldErrors(errors)
        : const <String, List<String>>{};

    final Object? topLevel = data['message'];
    if (topLevel is String && topLevel.isNotEmpty) {
      return _Body(message: topLevel, fieldErrors: fields);
    }

    final Object? meta = data['meta'];
    if (meta is Map) {
      final Object? metaMessage = meta['message'];
      if (metaMessage is String && metaMessage.isNotEmpty) {
        return _Body(message: metaMessage, fieldErrors: fields);
      }
    }

    return _Body(fieldErrors: fields);
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
