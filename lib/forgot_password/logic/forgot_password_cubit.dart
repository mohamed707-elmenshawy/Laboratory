import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/forgot_password_request_body.dart';
import '../data/repos/forgot_password_repo.dart';
part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._forgotPasswordRepo)
    : super(const ForgotPasswordInitial());

  final ForgotPasswordRepo _forgotPasswordRepo;

  final TextEditingController emailController = TextEditingController();

  bool get isBusy =>
      state is ForgotPasswordLoading || state is ForgotPasswordSuccess;

  Future<void> sendResetLink() async {
    if (isBusy) return;

    emit(const ForgotPasswordLoading());

    final String email = emailController.text.trim();

    final Result<void> result = await _forgotPasswordRepo.sendResetLink(
      ForgotPasswordRequestBody(email: email),
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(ForgotPasswordSuccess(email));
      case Failure<void>(:final AppError error):
        emit(ForgotPasswordFailure(error));
    }
  }

  void dismissFailure() {
    if (state is ForgotPasswordFailure) emit(const ForgotPasswordInitial());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
