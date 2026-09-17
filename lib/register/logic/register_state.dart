part of 'register_cubit.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => <Object?>[];
}

final class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

final class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

final class RegisterSuccess extends RegisterState {
  const RegisterSuccess(this.response);

  final RegisterResponse response;

  @override
  List<Object?> get props => <Object?>[response];
}

final class RegisterFailure extends RegisterState {
  const RegisterFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
