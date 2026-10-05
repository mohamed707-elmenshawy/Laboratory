import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/units_page.dart';
import '../data/models/units_query.dart';
import '../data/models/unit_model.dart';
import '../data/repos/units_repo.dart';
part 'units_state.dart';

class UnitsCubit extends Cubit<UnitsState> {
  UnitsCubit(this._unitsRepo) : super(const UnitsInitial());

  static const int defaultPerPage = 10;
  static const List<int> perPageOptions = <int>[10, 25, 50, 100];

  final UnitsRepo _unitsRepo;

  int _page = 1;
  int _perPage = defaultPerPage;
  String _search = '';
  UnitStatusFilter _status = UnitStatusFilter.all;
  int? _laboratoryId;

  int _requestId = 0;

  int get page => _page;
  int get perPage => _perPage;
  String get search => _search;
  UnitStatusFilter get status => _status;
  int? get laboratoryId => _laboratoryId;

  bool get hasFilters =>
      _search.isNotEmpty ||
      _status != UnitStatusFilter.all ||
      _laboratoryId != null;

  bool get isBusy => state is UnitsLoading;

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

  Future<void> changeStatus(UnitStatusFilter status) {
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
    _status = UnitStatusFilter.all;
    _laboratoryId = null;
    return _fetch(1);
  }

  void unitUpdated(UnitModel unit) {
    if (state case UnitsLoaded(:final UnitsPage page)) {
      emit(
        UnitsLoaded(
          UnitsPage(
            items: page.items
                .map((UnitModel item) => item.id == unit.id ? unit : item)
                .toList(growable: false),
            pagination: page.pagination,
          ),
        ),
      );
    }
  }

  Future<void> _fetch(int page) async {
    final int requestId = ++_requestId;

    emit(const UnitsLoading());

    final Result<UnitsPage> result = await _unitsRepo.fetchUnits(
      UnitsQuery(
        page: page,
        perPage: _perPage,
        search: _search,
        status: _status,
        laboratoryId: _laboratoryId,
      ),
    );

    if (isClosed || requestId != _requestId) return;

    switch (result) {
      case Success<UnitsPage>(:final UnitsPage data):
        _page = data.pagination.currentPage;

        if (data.items.isEmpty &&
            data.pagination.total > 0 &&
            data.pagination.currentPage > data.pagination.lastPage) {
          await _fetch(data.pagination.lastPage);
          return;
        }

        emit(UnitsLoaded(data));
      case Failure<UnitsPage>(:final AppError error):
        emit(UnitsFailure(error));
    }
  }
}
