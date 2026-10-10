part of 'parameter_form_cubit.dart';

sealed class ParameterFormState extends Equatable {
  const ParameterFormState();

  @override
  List<Object?> get props => <Object?>[];
}

final class ParameterFormInitial extends ParameterFormState {
  const ParameterFormInitial();
}

final class ParameterFormEditing extends ParameterFormState {
  const ParameterFormEditing(this.revision);

  final int revision;

  @override
  List<Object?> get props => <Object?>[revision];
}

final class ParameterFormLoading extends ParameterFormState {
  const ParameterFormLoading();
}

final class ParameterFormCreated extends ParameterFormState {
  const ParameterFormCreated();
}

final class ParameterFormSaved extends ParameterFormState {
  const ParameterFormSaved();
}

final class ParameterFormFailure extends ParameterFormState {
  const ParameterFormFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
