part of 'create_laboratory_cubit.dart';

sealed class CreateLaboratoryState extends Equatable {
  const CreateLaboratoryState();

  @override
  List<Object?> get props => <Object?>[];
}

final class CreateLaboratoryInitial extends CreateLaboratoryState {
  const CreateLaboratoryInitial();
}

final class CreateLaboratoryLangChanged extends CreateLaboratoryState {
  const CreateLaboratoryLangChanged(this.lang);

  final AppLocale lang;

  @override
  List<Object?> get props => <Object?>[lang];
}

final class CreateLaboratoryLoading extends CreateLaboratoryState {
  const CreateLaboratoryLoading();
}

final class CreateLaboratorySuccess extends CreateLaboratoryState {
  const CreateLaboratorySuccess();
}

final class CreateLaboratoryFailure extends CreateLaboratoryState {
  const CreateLaboratoryFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
