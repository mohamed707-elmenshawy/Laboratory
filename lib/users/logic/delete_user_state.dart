part of 'delete_user_cubit.dart';

sealed class DeleteUserState extends Equatable {
  const DeleteUserState();

  @override
  List<Object?> get props => <Object?>[];
}

final class DeleteUserInitial extends DeleteUserState {
  const DeleteUserInitial();
}

final class DeleteUserLoading extends DeleteUserState {
  const DeleteUserLoading();
}

final class DeleteUserSuccess extends DeleteUserState {
  const DeleteUserSuccess();
}

final class DeleteUserFailure extends DeleteUserState {
  const DeleteUserFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
