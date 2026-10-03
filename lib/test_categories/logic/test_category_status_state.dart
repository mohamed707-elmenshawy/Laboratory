part of 'test_category_status_cubit.dart';

sealed class TestCategoryStatusState extends Equatable {
  const TestCategoryStatusState();

  @override
  List<Object?> get props => <Object?>[];
}

final class TestCategoryStatusInitial extends TestCategoryStatusState {
  const TestCategoryStatusInitial();
}

final class TestCategoryStatusLoading extends TestCategoryStatusState {
  const TestCategoryStatusLoading(this.id);

  final int id;

  @override
  List<Object?> get props => <Object?>[id];
}

final class TestCategoryStatusSuccess extends TestCategoryStatusState {
  const TestCategoryStatusSuccess(this.category);

  final TestCategoryModel category;

  @override
  List<Object?> get props => <Object?>[category];
}

final class TestCategoryStatusFailure extends TestCategoryStatusState {
  const TestCategoryStatusFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
