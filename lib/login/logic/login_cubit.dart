import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/helpers/auth_helper.dart';
import '../../core/networking/app_error.dart';
import '../data/models/login_response.dart';
import '../data/repos/login_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginRepo) : super(const LoginState());

  final LoginRepo _loginRepo;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Timer? _retryTimer;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static const int _defaultRetryAfterSeconds = 60;

  Future<void> submit() {
    return signIn(
      email: emailController.text,
      password: passwordController.text,
      remember: state.rememberMe,
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
    required bool remember,
  }) async {
    if (state.isBusy) return;

    final LoginFieldIssue? emailIssue = _validateEmail(email);
    final LoginFieldIssue? passwordIssue = _validatePassword(password);

    if (emailIssue != null || passwordIssue != null) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          emailError: emailIssue == null ? null : ClientFieldError(emailIssue),
          passwordError: passwordIssue == null
              ? null
              : ClientFieldError(passwordIssue),
          clearEmailError: emailIssue == null,
          clearPasswordError: passwordIssue == null,
          clearFailure: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: LoginStatus.submitting,
        clearEmailError: true,
        clearPasswordError: true,
        clearFailure: true,
      ),
    );

    try {
      final LoginResponse response = await _loginRepo.login(
        email: email,
        password: password,
      );

      await AuthHelper.openSession(
        token: response.token,
        tenantId: response.user.tenantId,
        branchId: response.user.branchId,
        persist: remember,
      );

      emit(state.copyWith(status: LoginStatus.success, response: response));
    } catch (error) {
      final LoginState next = _stateForError(AppError.from(error));
      emit(next);
      if (next.isRateLimited) _startRetryCountdown();
    }
  }

  LoginState _stateForError(AppError error) {
    if (error.kind == AppErrorKind.validation && error.hasFieldErrors) {
      final String? emailMessage = error.fieldError('email');
      final String? passwordMessage = error.fieldError('password');

      return state.copyWith(
        status: LoginStatus.failure,
        emailError: emailMessage == null
            ? null
            : ServerFieldError(emailMessage),
        passwordError: passwordMessage == null
            ? null
            : ServerFieldError(passwordMessage),
        clearEmailError: emailMessage == null,
        clearPasswordError: passwordMessage == null,
        clearFailure: true,
      );
    }

    final LoginFailureKind kind = loginFailureFor(error);

    return state.copyWith(
      status: LoginStatus.failure,
      failure: kind,
      serverMessage: error.message,
      retryAfterSeconds: kind == LoginFailureKind.rateLimited
          ? (error.retryAfter?.inSeconds ?? _defaultRetryAfterSeconds)
          : null,
      clearEmailError: true,
      clearPasswordError: true,
    );
  }

  void onEmailChanged() {
    if (state.emailError == null && state.failure == null) return;
    if (state.isRateLimited && state.emailError == null) return;

    emit(
      state.copyWith(
        status: LoginStatus.idle,
        clearEmailError: true,
        clearFailure: true,
      ),
    );
  }

  void onPasswordChanged() {
    if (state.passwordError == null && state.failure == null) return;
    if (state.isRateLimited && state.passwordError == null) return;

    emit(
      state.copyWith(
        status: LoginStatus.idle,
        clearPasswordError: true,
        clearFailure: true,
      ),
    );
  }

  void onRememberMeChanged(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  void dismissFailure() {
    if (state.failure == null) return;
    _stopRetryCountdown();
    emit(state.copyWith(status: LoginStatus.idle, clearFailure: true));
  }

  void onLocaleChanged() {
    if (state.serverMessage == null) return;
    if (state.isRateLimited) return;
    emit(state.copyWith(status: LoginStatus.idle, clearFailure: true));
  }

  void _startRetryCountdown() {
    _stopRetryCountdown();
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final int remaining = (state.retryAfterSeconds ?? 0) - 1;

      if (remaining <= 0) {
        _stopRetryCountdown();
        emit(state.copyWith(status: LoginStatus.idle, clearFailure: true));
        return;
      }

      emit(state.copyWith(retryAfterSeconds: remaining));
    });
  }

  void _stopRetryCountdown() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  @override
  Future<void> close() {
    _stopRetryCountdown();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  LoginFieldIssue? _validateEmail(String value) {
    final String email = value.trim();

    if (email.isEmpty) return LoginFieldIssue.emailRequired;
    if (email.length > 255) return LoginFieldIssue.emailTooLong;
    if (!_emailPattern.hasMatch(email)) return LoginFieldIssue.emailInvalid;
    return null;
  }

  LoginFieldIssue? _validatePassword(String value) {
    if (value.isEmpty) return LoginFieldIssue.passwordRequired;
    return null;
  }
}
