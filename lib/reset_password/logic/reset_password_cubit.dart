import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/reset_password_link.dart';
import '../data/models/reset_password_request_body.dart';
import '../data/repos/reset_password_repo.dart';
part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._resetPasswordRepo)
    : super(const ResetPasswordInitial());

  final ResetPasswordRepo _resetPasswordRepo;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();

  ResetPasswordLink link = const ResetPasswordLink(email: '', token: '');

  bool get isBusy =>
      state is ResetPasswordLoading || state is ResetPasswordSuccess;

  Future<void> resetPassword() async {
    if (isBusy) return;

    emit(const ResetPasswordLoading());

    final Result<void> result = await _resetPasswordRepo.resetPassword(
      ResetPasswordRequestBody(
        token: link.token,
        email: link.email,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
      ),
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const ResetPasswordSuccess());
      case Failure<void>(:final AppError error):
        emit(ResetPasswordFailure(error));
    }
  }

  void dismissFailure() {
    if (state is ResetPasswordFailure) emit(const ResetPasswordInitial());
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    passwordConfirmationController.dispose();
    return super.close();
  }
}
