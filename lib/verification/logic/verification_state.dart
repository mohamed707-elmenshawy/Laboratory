part of 'verification_cubit.dart';

sealed class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object?> get props => <Object?>[];
}

final class VerificationInitial extends VerificationState {
  const VerificationInitial();
}

final class VerificationLoading extends VerificationState {
  const VerificationLoading();
}

final class VerificationSuccess extends VerificationState {
  const VerificationSuccess(this.response);

  final VerificationResponse response;

  @override
  List<Object?> get props => <Object?>[response];
}

final class VerificationFailure extends VerificationState {
  const VerificationFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
