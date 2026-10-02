import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/branch_model.dart';
import '../data/repos/branches_repo.dart';
part 'branch_details_state.dart';

class BranchDetailsCubit extends Cubit<BranchDetailsState> {
  BranchDetailsCubit(this._branchesRepo) : super(const BranchDetailsInitial());

  final BranchesRepo _branchesRepo;

  int _id = 0;

  int get id => _id;

  Future<void> load(int id) async {
    if (state is BranchDetailsLoading) return;

    _id = id;
    emit(const BranchDetailsLoading());

    final Result<BranchModel> result = await _branchesRepo.fetchBranch(id);

    if (isClosed) return;

    switch (result) {
      case Success<BranchModel>(:final BranchModel data):
        emit(BranchDetailsLoaded(data));
      case Failure<BranchModel>(:final AppError error):
        emit(BranchDetailsFailure(error));
    }
  }

  Future<void> reload() => load(_id);

  void branchUpdated(BranchModel branch) => emit(BranchDetailsLoaded(branch));
}
