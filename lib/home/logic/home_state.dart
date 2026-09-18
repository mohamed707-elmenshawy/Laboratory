part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => <Object?>[];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded(this.user);

  final UserModel user;

  @override
  List<Object?> get props => <Object?>[user.id, user.name, user.email];
}

final class HomeFailure extends HomeState {
  const HomeFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}

final class HomeSessionExpired extends HomeState {
  const HomeSessionExpired();
}
