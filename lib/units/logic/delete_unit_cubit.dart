import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/repos/units_repo.dart';
part 'delete_unit_state.dart';

class DeleteUnitCubit extends Cubit<DeleteUnitState> {
  DeleteUnitCubit(this._unitsRepo) : super(const DeleteUnitInitial());

  final UnitsRepo _unitsRepo;

  bool get isBusy => state is DeleteUnitLoading;

  Future<void> delete(int id) async {
    if (isBusy) return;

    emit(const DeleteUnitLoading());

    final Result<void> result = await _unitsRepo.deleteUnit(id);

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const DeleteUnitSuccess());
      case Failure<void>(:final AppError error):
        emit(DeleteUnitFailure(error));
    }
  }

  void dismissFailure() {
    if (state is DeleteUnitFailure) {
      emit(const DeleteUnitInitial());
    }
  }
}
