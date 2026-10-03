part of 'test_category_details_cubit.dart';

sealed class TestCategoryDetailsState extends Equatable {
  const TestCategoryDetailsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class TestCategoryDetailsInitial extends TestCategoryDetailsState {
  const TestCategoryDetailsInitial();
}

final class TestCategoryDetailsLoading extends TestCategoryDetailsState {
  const TestCategoryDetailsLoading();
}

final class TestCategoryDetailsLoaded extends TestCategoryDetailsState {
  const TestCategoryDetailsLoaded(this.category);

  final TestCategoryModel category;

  @override
  List<Object?> get props => <Object?>[category];
}

final class TestCategoryDetailsFailure extends TestCategoryDetailsState {
  const TestCategoryDetailsFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
