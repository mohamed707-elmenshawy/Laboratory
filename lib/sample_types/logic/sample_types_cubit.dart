import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/sample_types_page.dart';
import '../data/models/sample_types_query.dart';
import '../data/models/sample_type_model.dart';
import '../data/repos/sample_types_repo.dart';
part 'sample_types_state.dart';

class SampleTypesCubit extends Cubit<SampleTypesState> {
  SampleTypesCubit(this._sampleTypesRepo) : super(const SampleTypesInitial());

  static const int defaultPerPage = 10;
  static const List<int> perPageOptions = <int>[10, 25, 50, 100];

  final SampleTypesRepo _sampleTypesRepo;

  int _page = 1;
  int _perPage = defaultPerPage;
  String _search = '';
  SampleTypeStatusFilter _status = SampleTypeStatusFilter.all;
  int? _laboratoryId;

  int _requestId = 0;

  int get page => _page;
  int get perPage => _perPage;
  String get search => _search;
  SampleTypeStatusFilter get status => _status;
  int? get laboratoryId => _laboratoryId;

  bool get hasFilters =>
      _search.isNotEmpty ||
      _status != SampleTypeStatusFilter.all ||
      _laboratoryId != null;

  bool get isBusy => state is SampleTypesLoading;

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

  Future<void> changeStatus(SampleTypeStatusFilter status) {
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
    _status = SampleTypeStatusFilter.all;
    _laboratoryId = null;
    return _fetch(1);
  }

  void sampleTypeUpdated(SampleTypeModel sampleType) {
    if (state case SampleTypesLoaded(:final SampleTypesPage page)) {
      emit(
        SampleTypesLoaded(
          SampleTypesPage(
            items: page.items
                .map(
                  (SampleTypeModel item) =>
                      item.id == sampleType.id ? sampleType : item,
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

    emit(const SampleTypesLoading());

    final Result<SampleTypesPage> result = await _sampleTypesRepo
        .fetchSampleTypes(
          SampleTypesQuery(
            page: page,
            perPage: _perPage,
            search: _search,
            status: _status,
            laboratoryId: _laboratoryId,
          ),
        );

    if (isClosed || requestId != _requestId) return;

    switch (result) {
      case Success<SampleTypesPage>(:final SampleTypesPage data):
        _page = data.pagination.currentPage;

        if (data.items.isEmpty &&
            data.pagination.total > 0 &&
            data.pagination.currentPage > data.pagination.lastPage) {
          await _fetch(data.pagination.lastPage);
          return;
        }

        emit(SampleTypesLoaded(data));
      case Failure<SampleTypesPage>(:final AppError error):
        emit(SampleTypesFailure(error));
    }
  }
}
