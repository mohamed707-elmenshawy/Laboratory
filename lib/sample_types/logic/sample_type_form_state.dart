part of 'sample_type_form_cubit.dart';

sealed class SampleTypeFormState extends Equatable {
  const SampleTypeFormState();

  @override
  List<Object?> get props => <Object?>[];
}

final class SampleTypeFormInitial extends SampleTypeFormState {
  const SampleTypeFormInitial();
}

final class SampleTypeFormEditing extends SampleTypeFormState {
  const SampleTypeFormEditing(this.revision);

  final int revision;

  @override
  List<Object?> get props => <Object?>[revision];
}

final class SampleTypeFormLoading extends SampleTypeFormState {
  const SampleTypeFormLoading();
}

final class SampleTypeFormCreated extends SampleTypeFormState {
  const SampleTypeFormCreated();
}

final class SampleTypeFormSaved extends SampleTypeFormState {
  const SampleTypeFormSaved();
}

final class SampleTypeFormFailure extends SampleTypeFormState {
  const SampleTypeFormFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
