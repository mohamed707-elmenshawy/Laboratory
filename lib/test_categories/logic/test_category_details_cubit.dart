import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/test_category_model.dart';
import '../data/repos/test_categories_repo.dart';
part 'test_category_details_state.dart';

class TestCategoryDetailsCubit extends Cubit<TestCategoryDetailsState> {
  TestCategoryDetailsCubit(this._testCategoriesRepo)
    : super(const TestCategoryDetailsInitial());

  final TestCategoriesRepo _testCategoriesRepo;

  int _id = 0;

  int get id => _id;

  Future<void> load(int id) async {
    if (state is TestCategoryDetailsLoading) return;

    _id = id;
    emit(const TestCategoryDetailsLoading());

    final Result<TestCategoryModel> result = await _testCategoriesRepo
        .fetchTestCategory(id);

    if (isClosed) return;

    switch (result) {
      case Success<TestCategoryModel>(:final TestCategoryModel data):
        emit(TestCategoryDetailsLoaded(data));
      case Failure<TestCategoryModel>(:final AppError error):
        emit(TestCategoryDetailsFailure(error));
    }
  }

  Future<void> reload() => load(_id);

  void categoryUpdated(TestCategoryModel category) =>
      emit(TestCategoryDetailsLoaded(category));
}
