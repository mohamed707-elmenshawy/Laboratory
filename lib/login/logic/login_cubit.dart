import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../../core/helpers/auth_helper.dart';
import '../data/models/login_request_body.dart';
import '../data/models/login_response.dart';
import '../data/repos/login_repo.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginRepo) : super(const LoginInitial());

  final LoginRepo _loginRepo;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;

  bool get isBusy => state is LoginLoading || state is LoginSuccess;

  Future<void> login() async {
    if (isBusy) return;

    emit(const LoginLoading());

    final Result<LoginResponse> result = await _loginRepo.login(
      LoginRequestBody(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );

    switch (result) {
      case Success<LoginResponse>(:final LoginResponse data):
        await AuthHelper.openSession(
          token: data.token,
          tenantId: data.user.tenantId,
          branchId: data.user.branchId,
          persist: rememberMe,
        );
        if (isClosed) return;
        emit(LoginSuccess(data));
      case Failure<LoginResponse>(:final AppError error):
        if (isClosed) return;
        emit(LoginFailure(error));
    }
  }

  void dismissFailure() {
    if (state is LoginFailure) emit(const LoginInitial());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
