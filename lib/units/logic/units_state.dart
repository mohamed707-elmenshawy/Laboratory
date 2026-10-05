part of 'units_cubit.dart';

sealed class UnitsState extends Equatable {
  const UnitsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class UnitsInitial extends UnitsState {
  const UnitsInitial();
}

final class UnitsLoading extends UnitsState {
  const UnitsLoading();
}

final class UnitsLoaded extends UnitsState {
  const UnitsLoaded(this.page);

  final UnitsPage page;

  @override
  List<Object?> get props => <Object?>[page];
}

final class UnitsFailure extends UnitsState {
  const UnitsFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
