part of 'laboratories_cubit.dart';

sealed class LaboratoriesState extends Equatable {
  const LaboratoriesState();

  @override
  List<Object?> get props => <Object?>[];
}

final class LaboratoriesInitial extends LaboratoriesState {
  const LaboratoriesInitial();
}

final class LaboratoriesLoading extends LaboratoriesState {
  const LaboratoriesLoading();
}

final class LaboratoriesLoaded extends LaboratoriesState {
  const LaboratoriesLoaded(this.page);

  final LaboratoriesPage page;

  @override
  List<Object?> get props => <Object?>[page];
}

final class LaboratoriesFailure extends LaboratoriesState {
  const LaboratoriesFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
