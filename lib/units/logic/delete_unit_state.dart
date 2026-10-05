part of 'delete_unit_cubit.dart';

sealed class DeleteUnitState extends Equatable {
  const DeleteUnitState();

  @override
  List<Object?> get props => <Object?>[];
}

final class DeleteUnitInitial extends DeleteUnitState {
  const DeleteUnitInitial();
}

final class DeleteUnitLoading extends DeleteUnitState {
  const DeleteUnitLoading();
}

final class DeleteUnitSuccess extends DeleteUnitState {
  const DeleteUnitSuccess();
}

final class DeleteUnitFailure extends DeleteUnitState {
  const DeleteUnitFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
