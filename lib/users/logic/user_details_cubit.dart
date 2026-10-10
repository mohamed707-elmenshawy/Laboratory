import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/user_model.dart';
import '../data/repos/users_repo.dart';
part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit(this._usersRepo) : super(const UserDetailsInitial());

  final UsersRepo _usersRepo;

  int _id = 0;

  int get id => _id;

  Future<void> load(int id) async {
    if (state is UserDetailsLoading) return;

    _id = id;
    emit(const UserDetailsLoading());

    final Result<UserModel> result = await _usersRepo.fetchUser(id);

    if (isClosed) return;

    switch (result) {
      case Success<UserModel>(:final UserModel data):
        emit(UserDetailsLoaded(data));
      case Failure<UserModel>(:final AppError error):
        emit(UserDetailsFailure(error));
    }
  }

  Future<void> reload() => load(_id);

  void userUpdated(UserModel user) => emit(UserDetailsLoaded(user));
}
