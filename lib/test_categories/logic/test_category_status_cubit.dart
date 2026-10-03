import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/test_category_model.dart';
import '../data/repos/test_categories_repo.dart';
part 'test_category_status_state.dart';

class TestCategoryStatusCubit extends Cubit<TestCategoryStatusState> {
  TestCategoryStatusCubit(this._testCategoriesRepo)
    : super(const TestCategoryStatusInitial());

  final TestCategoriesRepo _testCategoriesRepo;

  bool get isBusy => state is TestCategoryStatusLoading;

  bool isBusyFor(int id) => switch (state) {
    TestCategoryStatusLoading(id: final int pending) => pending == id,
    _ => false,
  };

  Future<void> toggle(TestCategoryModel category) async {
    if (isBusy) return;

    final bool active = !category.isActive;
    emit(TestCategoryStatusLoading(category.id));

    final Result<void> result = await _testCategoriesRepo
        .setTestCategoryActive(category.id, active);

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(TestCategoryStatusSuccess(category.withActive(active)));
      case Failure<void>(:final AppError error):
        emit(TestCategoryStatusFailure(error));
    }
  }

  void reset() {
    if (state is TestCategoryStatusInitial) return;
    emit(const TestCategoryStatusInitial());
  }
}
