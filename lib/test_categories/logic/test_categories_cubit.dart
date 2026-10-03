import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/test_categories_page.dart';
import '../data/models/test_categories_query.dart';
import '../data/models/test_category_model.dart';
import '../data/repos/test_categories_repo.dart';
part 'test_categories_state.dart';

class TestCategoriesCubit extends Cubit<TestCategoriesState> {
  TestCategoriesCubit(this._testCategoriesRepo)
    : super(const TestCategoriesInitial());

  static const int defaultPerPage = 10;
  static const List<int> perPageOptions = <int>[10, 25, 50, 100];

  final TestCategoriesRepo _testCategoriesRepo;

  int _page = 1;
  int _perPage = defaultPerPage;
  String _search = '';
  TestCategoryStatusFilter _status = TestCategoryStatusFilter.all;
  int? _laboratoryId;

  int _requestId = 0;

  int get page => _page;
  int get perPage => _perPage;
  String get search => _search;
  TestCategoryStatusFilter get status => _status;
  int? get laboratoryId => _laboratoryId;

  bool get hasFilters =>
      _search.isNotEmpty ||
      _status != TestCategoryStatusFilter.all ||
      _laboratoryId != null;

  bool get isBusy => state is TestCategoriesLoading;

  Future<void> load() => _fetch(_page);

  Future<void> retry() => _fetch(_page);

  Future<void> goToPage(int page) {
    if (page == _page) return Future<void>.value();
    return _fetch(page);
  }

  Future<void> changePerPage(int perPage) {
    if (perPage == _perPage) return Future<void>.value();
    _perPage = perPage;
    return _fetch(1);
  }

  Future<void> changeSearch(String search) {
    final String term = search.trim();
    if (term == _search) return Future<void>.value();
    _search = term;
    return _fetch(1);
  }

  Future<void> changeStatus(TestCategoryStatusFilter status) {
    if (status == _status) return Future<void>.value();
    _status = status;
    return _fetch(1);
  }

  Future<void> changeLaboratory(int? laboratoryId) {
    if (laboratoryId == _laboratoryId) return Future<void>.value();
    _laboratoryId = laboratoryId;
    return _fetch(1);
  }

  Future<void> clearFilters() {
    if (!hasFilters) return Future<void>.value();
    _search = '';
    _status = TestCategoryStatusFilter.all;
    _laboratoryId = null;
    return _fetch(1);
  }

  void testCategoryUpdated(TestCategoryModel category) {
    if (state case TestCategoriesLoaded(:final TestCategoriesPage page)) {
      emit(
        TestCategoriesLoaded(
          TestCategoriesPage(
            items: page.items
                .map(
                  (TestCategoryModel item) =>
                      item.id == category.id ? category : item,
                )
                .toList(growable: false),
            pagination: page.pagination,
          ),
        ),
      );
    }
  }

  Future<void> _fetch(int page) async {
    final int requestId = ++_requestId;

    emit(const TestCategoriesLoading());

    final Result<TestCategoriesPage> result = await _testCategoriesRepo
        .fetchTestCategories(
          TestCategoriesQuery(
            page: page,
            perPage: _perPage,
            search: _search,
            status: _status,
            laboratoryId: _laboratoryId,
          ),
        );

    if (isClosed || requestId != _requestId) return;

    switch (result) {
      case Success<TestCategoriesPage>(:final TestCategoriesPage data):
        _page = data.pagination.currentPage;

        if (data.items.isEmpty &&
            data.pagination.total > 0 &&
            data.pagination.currentPage > data.pagination.lastPage) {
          await _fetch(data.pagination.lastPage);
          return;
        }

        emit(TestCategoriesLoaded(data));
      case Failure<TestCategoriesPage>(:final AppError error):
        emit(TestCategoriesFailure(error));
    }
  }
}
