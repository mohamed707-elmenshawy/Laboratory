import '../../core/networking/app_error.dart';
import '../data/models/login_response.dart';

enum LoginStatus { idle, submitting, success, failure }

enum LoginFieldIssue {
  emailRequired,
  emailInvalid,
  emailTooLong,
  passwordRequired,
}

sealed class LoginFieldError {
  const LoginFieldError();
}

class ClientFieldError extends LoginFieldError {
  const ClientFieldError(this.issue);

  final LoginFieldIssue issue;
}

class ServerFieldError extends LoginFieldError {
  const ServerFieldError(this.message);

  final String message;
}

enum LoginFailureKind {
  badCredentials,
  accountUnverified,
  rateLimited,
  server,
  network,
}

class LoginState {
  const LoginState({
    this.status = LoginStatus.idle,
    this.emailError,
    this.passwordError,
    this.failure,
    this.serverMessage,
    this.retryAfterSeconds,
    this.response,
    this.rememberMe = false,
  });

  final LoginStatus status;
  final LoginFieldError? emailError;
  final LoginFieldError? passwordError;
  final LoginFailureKind? failure;
  final String? serverMessage;
  final int? retryAfterSeconds;
  final LoginResponse? response;
  final bool rememberMe;

  bool get isSubmitting => status == LoginStatus.submitting;
  bool get isSuccess => status == LoginStatus.success;
  bool get isBusy => isSubmitting || isSuccess;

  bool get isRateLimited =>
      failure == LoginFailureKind.rateLimited && (retryAfterSeconds ?? 0) > 0;

  bool get canSubmit => !isBusy && !isRateLimited;

  LoginState copyWith({
    LoginStatus? status,
    LoginFieldError? emailError,
    LoginFieldError? passwordError,
    LoginFailureKind? failure,
    String? serverMessage,
    int? retryAfterSeconds,
    LoginResponse? response,
    bool? rememberMe,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearFailure = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError
          ? null
          : (passwordError ?? this.passwordError),
      failure: clearFailure ? null : (failure ?? this.failure),
      serverMessage: clearFailure
          ? null
          : (serverMessage ?? this.serverMessage),
      retryAfterSeconds: clearFailure
          ? null
          : (retryAfterSeconds ?? this.retryAfterSeconds),
      response: response ?? this.response,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

LoginFailureKind loginFailureFor(AppError error) => switch (error.kind) {
  AppErrorKind.unauthorized => LoginFailureKind.badCredentials,
  AppErrorKind.forbidden => LoginFailureKind.accountUnverified,
  AppErrorKind.rateLimited => LoginFailureKind.rateLimited,
  AppErrorKind.network ||
  AppErrorKind.timeout ||
  AppErrorKind.cancelled => LoginFailureKind.network,
  AppErrorKind.server ||
  AppErrorKind.validation ||
  AppErrorKind.badRequest ||
  AppErrorKind.notFound ||
  AppErrorKind.unknown => LoginFailureKind.server,
};
