import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/register_request_body.dart';
import '../data/models/register_response.dart';
import '../data/repos/register_repo.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._registerRepo) : super(const RegisterInitial());

  final RegisterRepo _registerRepo;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();

  bool acceptedTerms = false;

  bool get isBusy => state is RegisterLoading || state is RegisterSuccess;

  Future<void> register() async {
    if (isBusy) return;

    emit(const RegisterLoading());

    final Result<RegisterResponse> result = await _registerRepo.register(
      RegisterRequestBody(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
        termAndCondition: acceptedTerms,
      ),
    );

    if (isClosed) return;

    switch (result) {
      case Success<RegisterResponse>(:final RegisterResponse data):
        emit(RegisterSuccess(data));
      case Failure<RegisterResponse>(:final AppError error):
        emit(RegisterFailure(error));
    }
  }

  void dismissFailure() {
    if (state is RegisterFailure) emit(const RegisterInitial());
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    return super.close();
  }
}
