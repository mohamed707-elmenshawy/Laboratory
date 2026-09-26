part of 'laboratory_status_cubit.dart';

sealed class LaboratoryStatusState extends Equatable {
  const LaboratoryStatusState();

  @override
  List<Object?> get props => <Object?>[];
}

final class LaboratoryStatusInitial extends LaboratoryStatusState {
  const LaboratoryStatusInitial();
}

final class LaboratoryStatusLoading extends LaboratoryStatusState {
  const LaboratoryStatusLoading(this.id);

  final int id;

  @override
  List<Object?> get props => <Object?>[id];
}

final class LaboratoryStatusSuccess extends LaboratoryStatusState {
  const LaboratoryStatusSuccess(this.laboratory);

  final LaboratoryModel laboratory;

  @override
  List<Object?> get props => <Object?>[laboratory];
}

final class LaboratoryStatusFailure extends LaboratoryStatusState {
  const LaboratoryStatusFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
