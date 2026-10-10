part of 'users_cubit.dart';

sealed class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => <Object?>[];
}

final class UsersInitial extends UsersState {
  const UsersInitial();
}

final class UsersLoading extends UsersState {
  const UsersLoading();
}

final class UsersLoaded extends UsersState {
  const UsersLoaded(this.page);

  final UsersPage page;

  @override
  List<Object?> get props => <Object?>[page];
}

final class UsersFailure extends UsersState {
  const UsersFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
