import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/branch_model.dart';
import '../data/repos/branches_repo.dart';
part 'branch_status_state.dart';

class BranchStatusCubit extends Cubit<BranchStatusState> {
  BranchStatusCubit(this._branchesRepo) : super(const BranchStatusInitial());

  final BranchesRepo _branchesRepo;

  bool get isBusy => state is BranchStatusLoading;

  bool isBusyFor(int id) => switch (state) {
    BranchStatusLoading(id: final int pending) => pending == id,
    _ => false,
  };

  Future<void> toggle(BranchModel branch) async {
    if (isBusy) return;

    final bool active = !branch.isActive;
    emit(BranchStatusLoading(branch.id));

    final Result<void> result = await _branchesRepo.setBranchActive(
      branch.id,
      active,
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(BranchStatusSuccess(branch.withActive(active)));
      case Failure<void>(:final AppError error):
        emit(BranchStatusFailure(error));
    }
  }

  void reset() {
    if (state is BranchStatusInitial) return;
    emit(const BranchStatusInitial());
  }
}
