import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/user_model.dart';
import '../data/models/users_page.dart';
import '../data/models/users_query.dart';
import '../data/repos/users_repo.dart';
part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this._usersRepo) : super(const UsersInitial());

  static const int defaultPerPage = 10;
  static const List<int> perPageOptions = <int>[10, 25, 50, 100];

  final UsersRepo _usersRepo;

  int _page = 1;
  int _perPage = defaultPerPage;
  String _search = '';
  int? _laboratoryId;

  int _requestId = 0;

  int get page => _page;
  int get perPage => _perPage;
  String get search => _search;
  int? get laboratoryId => _laboratoryId;

  bool get hasFilters => _search.isNotEmpty || _laboratoryId != null;

  bool get isBusy => state is UsersLoading;

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

  Future<void> changeLaboratory(int? laboratoryId) {
    if (laboratoryId == _laboratoryId) return Future<void>.value();
    _laboratoryId = laboratoryId;
    return _fetch(1);
  }

  Future<void> clearFilters() {
    if (!hasFilters) return Future<void>.value();
    _search = '';
    _laboratoryId = null;
    return _fetch(1);
  }

  void userUpdated(UserModel user) {
    if (state case UsersLoaded(:final UsersPage page)) {
      emit(
        UsersLoaded(
          UsersPage(
            items: page.items
                .map((UserModel item) => item.id == user.id ? user : item)
                .toList(growable: false),
            pagination: page.pagination,
          ),
        ),
      );
    }
  }

  Future<void> _fetch(int page) async {
    final int requestId = ++_requestId;

    emit(const UsersLoading());

    final Result<UsersPage> result = await _usersRepo.fetchUsers(
      UsersQuery(
        page: page,
        perPage: _perPage,
        search: _search,
        laboratoryId: _laboratoryId,
      ),
    );

    if (isClosed || requestId != _requestId) return;

    switch (result) {
      case Success<UsersPage>(:final UsersPage data):
        _page = data.pagination.currentPage;

        if (data.items.isEmpty &&
            data.pagination.total > 0 &&
            data.pagination.currentPage > data.pagination.lastPage) {
          await _fetch(data.pagination.lastPage);
          return;
        }

        emit(UsersLoaded(data));
      case Failure<UsersPage>(:final AppError error):
        emit(UsersFailure(error));
    }
  }
}
