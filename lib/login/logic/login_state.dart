part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => <Object?>[];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess(this.response);

  final LoginResponse response;

  @override
  List<Object?> get props => <Object?>[response];
}

final class LoginFailure extends LoginState {
  const LoginFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
