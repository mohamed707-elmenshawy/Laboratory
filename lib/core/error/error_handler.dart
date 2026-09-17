import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'app_error.dart';
import 'result.dart';

class ErrorHandler {
  ErrorHandler._();

  static Future<Result<T>> guard<T>(Future<T> Function() action) async {
    try {
      return Success<T>(await action());
    } catch (error, stackTrace) {
      return Failure<T>(_handle(error, stackTrace));
    }
  }

  static AppError _handle(Object error, StackTrace stackTrace) {
    if (error is DioException) return _fromDio(error);

    developer.log(
      'Unexpected error',
      name: 'ErrorHandler',
      error: error,
      stackTrace: stackTrace,
    );
    return const AppError(kind: AppErrorKind.unknown);
  }

  static AppError _fromDio(DioException exception) {
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
}

class _Body {
  final String? message;
  final Map<String, List<String>> fieldErrors;

  const _Body({
    this.message,
    this.fieldErrors = const <String, List<String>>{},
  });

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
