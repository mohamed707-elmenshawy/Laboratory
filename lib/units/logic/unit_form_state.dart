part of 'unit_form_cubit.dart';

sealed class UnitFormState extends Equatable {
  const UnitFormState();

  @override
  List<Object?> get props => <Object?>[];
}

final class UnitFormInitial extends UnitFormState {
  const UnitFormInitial();
}

final class UnitFormEditing extends UnitFormState {
  const UnitFormEditing(this.revision);

  final int revision;

  @override
  List<Object?> get props => <Object?>[revision];
}

final class UnitFormLoading extends UnitFormState {
  const UnitFormLoading();
}

final class UnitFormCreated extends UnitFormState {
  const UnitFormCreated();
}

final class UnitFormSaved extends UnitFormState {
  const UnitFormSaved();
}

final class UnitFormFailure extends UnitFormState {
  const UnitFormFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
