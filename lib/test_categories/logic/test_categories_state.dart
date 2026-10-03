part of 'test_categories_cubit.dart';

sealed class TestCategoriesState extends Equatable {
  const TestCategoriesState();

  @override
  List<Object?> get props => <Object?>[];
}

final class TestCategoriesInitial extends TestCategoriesState {
  const TestCategoriesInitial();
}

final class TestCategoriesLoading extends TestCategoriesState {
  const TestCategoriesLoading();
}

final class TestCategoriesLoaded extends TestCategoriesState {
  const TestCategoriesLoaded(this.page);

  final TestCategoriesPage page;

  @override
  List<Object?> get props => <Object?>[page];
}

final class TestCategoriesFailure extends TestCategoriesState {
  const TestCategoriesFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
