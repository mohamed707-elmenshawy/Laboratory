part of 'user_details_cubit.dart';

sealed class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class UserDetailsInitial extends UserDetailsState {
  const UserDetailsInitial();
}

final class UserDetailsLoading extends UserDetailsState {
  const UserDetailsLoading();
}

final class UserDetailsLoaded extends UserDetailsState {
  const UserDetailsLoaded(this.user);

  final UserModel user;

  @override
  List<Object?> get props => <Object?>[user];
}

final class UserDetailsFailure extends UserDetailsState {
  const UserDetailsFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
