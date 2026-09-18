import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/verification_request_body.dart';
import '../data/models/verification_response.dart';
import '../data/repos/verification_repo.dart';
part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit(this._verificationRepo)
    : super(const VerificationInitial());

  final VerificationRepo _verificationRepo;

  final TextEditingController codeController = TextEditingController();

  String email = '';

  bool get isBusy =>
      state is VerificationLoading || state is VerificationSuccess;

  Future<void> verify() async {
    if (isBusy) return;

    emit(const VerificationLoading());

    final Result<VerificationResponse> result = await _verificationRepo.verify(
      VerificationRequestBody(
        email: email.trim(),
        code: codeController.text.trim(),
      ),
    );

    if (isClosed) return;

    switch (result) {
      case Success<VerificationResponse>(:final VerificationResponse data):
        emit(VerificationSuccess(data));
      case Failure<VerificationResponse>(:final AppError error):
        emit(VerificationFailure(error));
    }
  }

  void dismissFailure() {
    if (state is VerificationFailure) emit(const VerificationInitial());
  }

  @override
  Future<void> close() {
    codeController.dispose();
    return super.close();
  }
}
