part of 'logout_cubit.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => <Object?>[];
}

final class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

final class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

final class LogoutSuccess extends LogoutState {
  const LogoutSuccess();
}
