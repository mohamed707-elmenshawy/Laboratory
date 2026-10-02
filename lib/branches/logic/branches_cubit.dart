import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/branch_model.dart';
import '../data/models/branches_page.dart';
import '../data/models/branches_query.dart';
import '../data/repos/branches_repo.dart';
part 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  BranchesCubit(this._branchesRepo) : super(const BranchesInitial());

  static const int defaultPerPage = 10;
  static const List<int> perPageOptions = <int>[10, 25, 50, 100];

  final BranchesRepo _branchesRepo;

  int _page = 1;
  int _perPage = defaultPerPage;
  String _search = '';
  BranchStatusFilter _status = BranchStatusFilter.all;
  int? _laboratoryId;

  int _requestId = 0;

  int get page => _page;
  int get perPage => _perPage;
  String get search => _search;
  BranchStatusFilter get status => _status;
  int? get laboratoryId => _laboratoryId;

  bool get hasFilters =>
      _search.isNotEmpty ||
      _status != BranchStatusFilter.all ||
      _laboratoryId != null;

  bool get isBusy => state is BranchesLoading;

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

  Future<void> changeStatus(BranchStatusFilter status) {
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
    _status = BranchStatusFilter.all;
    _laboratoryId = null;
    return _fetch(1);
  }

  void branchUpdated(BranchModel branch) {
    if (state case BranchesLoaded(:final BranchesPage page)) {
      emit(
        BranchesLoaded(
          BranchesPage(
            items: page.items
                .map((BranchModel item) => item.id == branch.id ? branch : item)
                .toList(growable: false),
            pagination: page.pagination,
          ),
        ),
      );
    }
  }

  Future<void> _fetch(int page) async {
    final int requestId = ++_requestId;

    emit(const BranchesLoading());

    final Result<BranchesPage> result = await _branchesRepo.fetchBranches(
      BranchesQuery(
        page: page,
        perPage: _perPage,
        search: _search,
        status: _status,
        laboratoryId: _laboratoryId,
      ),
    );

    if (isClosed || requestId != _requestId) return;

    switch (result) {
      case Success<BranchesPage>(:final BranchesPage data):
        _page = data.pagination.currentPage;

        if (data.items.isEmpty &&
            data.pagination.total > 0 &&
            data.pagination.currentPage > data.pagination.lastPage) {
          await _fetch(data.pagination.lastPage);
          return;
        }

        emit(BranchesLoaded(data));
      case Failure<BranchesPage>(:final AppError error):
        emit(BranchesFailure(error));
    }
  }
}
