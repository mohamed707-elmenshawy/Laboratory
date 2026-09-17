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
  unknown,
}

class AppError extends Equatable {
  final AppErrorKind kind;
  final String? message;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;
  final Duration? retryAfter;

  const AppError({
    required this.kind,
    this.message,
    this.statusCode,
    this.fieldErrors = const <String, List<String>>{},
    this.retryAfter,
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
