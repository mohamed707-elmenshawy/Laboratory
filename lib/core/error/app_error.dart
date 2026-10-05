import 'package:equatable/equatable.dart';

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

  /// The server answered, but the body did not match the expected shape.
  parsing,
  unknown,
}

/// An expected failure. Thrown by `ApiClient`, caught by `guard`, and carried
/// by `Failure`; nothing above a repository ever sees it thrown.
class AppError extends Equatable implements Exception {
  final AppErrorKind kind;
  final String? message;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;
  final Duration? retryAfter;

  /// The unexpected error this was built from, when the mapper had to
  /// swallow one (e.g. the `FormatException` behind a body that is not JSON).
  /// `guard` reports it. Not part of equality.
  final Object? cause;

  const AppError({
    required this.kind,
    this.message,
    this.statusCode,
    this.fieldErrors = const <String, List<String>>{},
    this.retryAfter,
    this.cause,
  });

  String? fieldError(String field) {
    final List<String>? messages = fieldErrors[field];
    return (messages == null || messages.isEmpty) ? null : messages.first;
  }

  bool get hasFieldErrors => fieldErrors.isNotEmpty;

  @override
  List<Object?> get props => <Object?>[
    kind,
    message,
    statusCode,
    fieldErrors,
    retryAfter,
  ];

  @override
  String toString() =>
      'AppError(${kind.name}, status: $statusCode, message: $message)';
}
