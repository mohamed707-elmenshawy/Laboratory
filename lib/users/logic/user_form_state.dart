part of 'user_form_cubit.dart';

sealed class UserFormState extends Equatable {
  const UserFormState();

  @override
  List<Object?> get props => <Object?>[];
}

final class UserFormInitial extends UserFormState {
  const UserFormInitial();
}

final class UserFormEditing extends UserFormState {
  const UserFormEditing(this.revision);

  final int revision;

  @override
  List<Object?> get props => <Object?>[revision];
}

final class UserFormLoading extends UserFormState {
  const UserFormLoading();
}

final class UserFormCreated extends UserFormState {
  const UserFormCreated();
}

final class UserFormSaved extends UserFormState {
  const UserFormSaved();
}

final class UserFormFailure extends UserFormState {
  const UserFormFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
