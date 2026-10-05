part of 'unit_status_cubit.dart';

sealed class UnitStatusState extends Equatable {
  const UnitStatusState();

  @override
  List<Object?> get props => <Object?>[];
}

final class UnitStatusInitial extends UnitStatusState {
  const UnitStatusInitial();
}

final class UnitStatusLoading extends UnitStatusState {
  const UnitStatusLoading(this.id);

  final int id;

  @override
  List<Object?> get props => <Object?>[id];
}

final class UnitStatusSuccess extends UnitStatusState {
  const UnitStatusSuccess(this.unit);

  final UnitModel unit;

  @override
  List<Object?> get props => <Object?>[unit];
}

final class UnitStatusFailure extends UnitStatusState {
  const UnitStatusFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
