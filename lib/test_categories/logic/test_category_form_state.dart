part of 'test_category_form_cubit.dart';

sealed class TestCategoryFormState extends Equatable {
  const TestCategoryFormState();

  @override
  List<Object?> get props => <Object?>[];
}

final class TestCategoryFormInitial extends TestCategoryFormState {
  const TestCategoryFormInitial();
}

final class TestCategoryFormEditing extends TestCategoryFormState {
  const TestCategoryFormEditing(this.revision);

  final int revision;

  @override
  List<Object?> get props => <Object?>[revision];
}

final class TestCategoryFormLoading extends TestCategoryFormState {
  const TestCategoryFormLoading();
}

final class TestCategoryFormCreated extends TestCategoryFormState {
  const TestCategoryFormCreated();
}

final class TestCategoryFormSaved extends TestCategoryFormState {
  const TestCategoryFormSaved();
}

final class TestCategoryFormFailure extends TestCategoryFormState {
  const TestCategoryFormFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
