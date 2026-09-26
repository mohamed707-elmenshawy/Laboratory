part of 'laboratory_details_cubit.dart';

sealed class LaboratoryDetailsState extends Equatable {
  const LaboratoryDetailsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class LaboratoryDetailsInitial extends LaboratoryDetailsState {
  const LaboratoryDetailsInitial();
}

final class LaboratoryDetailsLoading extends LaboratoryDetailsState {
  const LaboratoryDetailsLoading();
}

final class LaboratoryDetailsLoaded extends LaboratoryDetailsState {
  const LaboratoryDetailsLoaded(this.laboratory);

  final LaboratoryModel laboratory;

  @override
  List<Object?> get props => <Object?>[laboratory];
}

final class LaboratoryDetailsFailure extends LaboratoryDetailsState {
  const LaboratoryDetailsFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
