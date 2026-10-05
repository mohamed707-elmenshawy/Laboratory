part of 'unit_details_cubit.dart';

sealed class UnitDetailsState extends Equatable {
  const UnitDetailsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class UnitDetailsInitial extends UnitDetailsState {
  const UnitDetailsInitial();
}

final class UnitDetailsLoading extends UnitDetailsState {
  const UnitDetailsLoading();
}

final class UnitDetailsLoaded extends UnitDetailsState {
  const UnitDetailsLoaded(this.unit);

  final UnitModel unit;

  @override
  List<Object?> get props => <Object?>[unit];
}

final class UnitDetailsFailure extends UnitDetailsState {
  const UnitDetailsFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
