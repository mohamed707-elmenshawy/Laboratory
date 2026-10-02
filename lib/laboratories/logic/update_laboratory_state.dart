part of 'update_laboratory_cubit.dart';

sealed class UpdateLaboratoryState extends Equatable {
  const UpdateLaboratoryState();

  @override
  List<Object?> get props => <Object?>[];
}

final class UpdateLaboratoryInitial extends UpdateLaboratoryState {
  const UpdateLaboratoryInitial();
}

final class UpdateLaboratoryEditing extends UpdateLaboratoryState {
  const UpdateLaboratoryEditing(this.revision);

  final int revision;

  @override
  List<Object?> get props => <Object?>[revision];
}

final class UpdateLaboratoryLoading extends UpdateLaboratoryState {
  const UpdateLaboratoryLoading();
}

final class UpdateLaboratorySuccess extends UpdateLaboratoryState {
  const UpdateLaboratorySuccess(this.laboratory);

  final LaboratoryModel laboratory;

  @override
  List<Object?> get props => <Object?>[laboratory];
}

final class UpdateLaboratoryFailure extends UpdateLaboratoryState {
  const UpdateLaboratoryFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
