import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/repos/branches_repo.dart';
part 'delete_branch_state.dart';

class DeleteBranchCubit extends Cubit<DeleteBranchState> {
  DeleteBranchCubit(this._branchesRepo) : super(const DeleteBranchInitial());

  final BranchesRepo _branchesRepo;

  bool get isBusy => state is DeleteBranchLoading;

  Future<void> delete(int id) async {
    if (isBusy) return;

    emit(const DeleteBranchLoading());

    final Result<void> result = await _branchesRepo.deleteBranch(id);

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const DeleteBranchSuccess());
      case Failure<void>(:final AppError error):
        emit(DeleteBranchFailure(error));
    }
  }

  void dismissFailure() {
    if (state is DeleteBranchFailure) emit(const DeleteBranchInitial());
  }
}
