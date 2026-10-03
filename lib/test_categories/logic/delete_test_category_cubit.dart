import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/repos/test_categories_repo.dart';
part 'delete_test_category_state.dart';

class DeleteTestCategoryCubit extends Cubit<DeleteTestCategoryState> {
  DeleteTestCategoryCubit(this._testCategoriesRepo)
    : super(const DeleteTestCategoryInitial());

  final TestCategoriesRepo _testCategoriesRepo;

  bool get isBusy => state is DeleteTestCategoryLoading;

  Future<void> delete(int id) async {
    if (isBusy) return;

    emit(const DeleteTestCategoryLoading());

    final Result<void> result = await _testCategoriesRepo.deleteTestCategory(
      id,
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const DeleteTestCategorySuccess());
      case Failure<void>(:final AppError error):
        emit(DeleteTestCategoryFailure(error));
    }
  }

  void dismissFailure() {
    if (state is DeleteTestCategoryFailure) {
      emit(const DeleteTestCategoryInitial());
    }
  }
}
