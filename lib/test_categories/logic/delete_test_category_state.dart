part of 'delete_test_category_cubit.dart';

sealed class DeleteTestCategoryState extends Equatable {
  const DeleteTestCategoryState();

  @override
  List<Object?> get props => <Object?>[];
}

final class DeleteTestCategoryInitial extends DeleteTestCategoryState {
  const DeleteTestCategoryInitial();
}

final class DeleteTestCategoryLoading extends DeleteTestCategoryState {
  const DeleteTestCategoryLoading();
}

final class DeleteTestCategorySuccess extends DeleteTestCategoryState {
  const DeleteTestCategorySuccess();
}

final class DeleteTestCategoryFailure extends DeleteTestCategoryState {
  const DeleteTestCategoryFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
