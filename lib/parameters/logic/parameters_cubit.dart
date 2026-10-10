import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/parameters_page.dart';
import '../data/models/parameters_query.dart';
import '../data/models/parameter_model.dart';
import '../data/repos/parameters_repo.dart';
part 'parameters_state.dart';

class ParametersCubit extends Cubit<ParametersState> {
  ParametersCubit(this._parametersRepo) : super(const ParametersInitial());

  static const int defaultPerPage = 10;
  static const List<int> perPageOptions = <int>[10, 25, 50, 100];

  final ParametersRepo _parametersRepo;

  int _page = 1;
  int _perPage = defaultPerPage;
  String _search = '';
  ParameterStatusFilter _status = ParameterStatusFilter.all;
  int? _laboratoryId;

  int _requestId = 0;

  int get page => _page;
  int get perPage => _perPage;
  String get search => _search;
  ParameterStatusFilter get status => _status;
  int? get laboratoryId => _laboratoryId;

  bool get hasFilters =>
      _search.isNotEmpty ||
      _status != ParameterStatusFilter.all ||
      _laboratoryId != null;

  bool get isBusy => state is ParametersLoading;

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

  Future<void> changeStatus(ParameterStatusFilter status) {
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
    _status = ParameterStatusFilter.all;
    _laboratoryId = null;
    return _fetch(1);
  }

  void parameterUpdated(ParameterModel parameter) {
    if (state case ParametersLoaded(:final ParametersPage page)) {
      emit(
        ParametersLoaded(
          ParametersPage(
            items: page.items
                .map(
                  (ParameterModel item) =>
                      item.id == parameter.id ? parameter : item,
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

    emit(const ParametersLoading());

    final Result<ParametersPage> result = await _parametersRepo.fetchParameters(
      ParametersQuery(
        page: page,
        perPage: _perPage,
        search: _search,
        status: _status,
        laboratoryId: _laboratoryId,
      ),
    );

    if (isClosed || requestId != _requestId) return;

    switch (result) {
      case Success<ParametersPage>(:final ParametersPage data):
        _page = data.pagination.currentPage;

        if (data.items.isEmpty &&
            data.pagination.total > 0 &&
            data.pagination.currentPage > data.pagination.lastPage) {
          await _fetch(data.pagination.lastPage);
          return;
        }

        emit(ParametersLoaded(data));
      case Failure<ParametersPage>(:final AppError error):
        emit(ParametersFailure(error));
    }
  }
}
