part of 'delete_laboratory_cubit.dart';

sealed class DeleteLaboratoryState extends Equatable {
  const DeleteLaboratoryState();

  @override
  List<Object?> get props => <Object?>[];
}

final class DeleteLaboratoryInitial extends DeleteLaboratoryState {
  const DeleteLaboratoryInitial();
}

final class DeleteLaboratoryLoading extends DeleteLaboratoryState {
  const DeleteLaboratoryLoading();
}

final class DeleteLaboratorySuccess extends DeleteLaboratoryState {
  const DeleteLaboratorySuccess();
}

final class DeleteLaboratoryFailure extends DeleteLaboratoryState {
  const DeleteLaboratoryFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
