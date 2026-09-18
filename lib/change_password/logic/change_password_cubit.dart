import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/change_password_request_body.dart';
import '../data/repos/change_password_repo.dart';
part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._changePasswordRepo)
    : super(const ChangePasswordInitial());

  final ChangePasswordRepo _changePasswordRepo;

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();

  bool get isBusy => state is ChangePasswordLoading;

  Future<void> changePassword() async {
    if (isBusy) return;

    emit(const ChangePasswordLoading());

    final Result<void> result = await _changePasswordRepo.changePassword(
      ChangePasswordRequestBody(
        currentPassword: currentPasswordController.text,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
      ),
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        currentPasswordController.clear();
        passwordController.clear();
        passwordConfirmationController.clear();
        emit(const ChangePasswordSuccess());
      case Failure<void>(:final AppError error):
        emit(ChangePasswordFailure(error));
    }
  }

  void dismissFeedback() {
    if (state is ChangePasswordSuccess || state is ChangePasswordFailure) {
      emit(const ChangePasswordInitial());
    }
  }

  @override
  Future<void> close() {
    currentPasswordController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    return super.close();
  }
}
