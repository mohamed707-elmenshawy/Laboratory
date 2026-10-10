import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/repos/users_repo.dart';
part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit(this._usersRepo) : super(const DeleteUserInitial());

  final UsersRepo _usersRepo;

  bool get isBusy => state is DeleteUserLoading;

  Future<void> delete(int id) async {
    if (isBusy) return;

    emit(const DeleteUserLoading());

    final Result<void> result = await _usersRepo.deleteUser(id);

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const DeleteUserSuccess());
      case Failure<void>(:final AppError error):
        emit(DeleteUserFailure(error));
    }
  }

  void dismissFailure() {
    if (state is DeleteUserFailure) {
      emit(const DeleteUserInitial());
    }
  }
}
