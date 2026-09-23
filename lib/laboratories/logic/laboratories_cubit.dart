import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/laboratories_page.dart';
import '../data/models/laboratories_query.dart';
import '../data/repos/laboratories_repo.dart';
part 'laboratories_state.dart';

class LaboratoriesCubit extends Cubit<LaboratoriesState> {
  LaboratoriesCubit(this._laboratoriesRepo)
    : super(const LaboratoriesInitial());

  static const int defaultPageSize = 10;
  static const List<int> pageSizeOptions = <int>[10, 25, 50, 100];

  final LaboratoriesRepo _laboratoriesRepo;

  int _page = 1;
  int _pageSize = defaultPageSize;
  String _search = '';
  LaboratoryStatusFilter _status = LaboratoryStatusFilter.all;

  // Only the newest request may emit, so a slow response for an old
  // search term can't overwrite the results of the one typed after it.
  int _requestId = 0;

  int get page => _page;
  int get pageSize => _pageSize;
  String get search => _search;
  LaboratoryStatusFilter get status => _status;

  bool get hasFilters =>
      _search.isNotEmpty || _status != LaboratoryStatusFilter.all;

  bool get isBusy => state is LaboratoriesLoading;

  Future<void> load() => _fetch(_page);

  Future<void> retry() => _fetch(_page);

  Future<void> goToPage(int page) {
    if (page == _page) return Future<void>.value();
    return _fetch(page);
  }

  Future<void> changePageSize(int pageSize) {
    if (pageSize == _pageSize) return Future<void>.value();
    _pageSize = pageSize;
    return _fetch(1);
  }

  Future<void> changeSearch(String search) {
    final String term = search.trim();
    if (term == _search) return Future<void>.value();
    _search = term;
    return _fetch(1);
  }

  Future<void> changeStatus(LaboratoryStatusFilter status) {
    if (status == _status) return Future<void>.value();
    _status = status;
    return _fetch(1);
  }

  Future<void> clearFilters() {
    if (!hasFilters) return Future<void>.value();
    _search = '';
    _status = LaboratoryStatusFilter.all;
    return _fetch(1);
  }

  Future<void> _fetch(int page) async {
    final int requestId = ++_requestId;

    emit(const LaboratoriesLoading());

    final Result<LaboratoriesPage> result = await _laboratoriesRepo
        .fetchLaboratories(
          LaboratoriesQuery(
            page: page,
            pageSize: _pageSize,
            search: _search,
            status: _status,
          ),
        );

    if (isClosed || requestId != _requestId) return;

    switch (result) {
      case Success<LaboratoriesPage>(:final LaboratoriesPage data):
        _page = data.pagination.currentPage;

        if (data.items.isEmpty &&
            data.pagination.total > 0 &&
            data.pagination.currentPage > data.pagination.lastPage) {
          emit(const LaboratoriesInitial());
          await _fetch(data.pagination.lastPage);
          return;
        }

        emit(LaboratoriesLoaded(data));
      case Failure<LaboratoriesPage>(:final AppError error):
        emit(LaboratoriesFailure(error));
    }
  }
}
