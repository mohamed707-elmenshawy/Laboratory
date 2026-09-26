import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/laboratory_model.dart';
import '../data/repos/laboratories_repo.dart';
part 'laboratory_status_state.dart';

class LaboratoryStatusCubit extends Cubit<LaboratoryStatusState> {
  LaboratoryStatusCubit(this._laboratoriesRepo)
    : super(const LaboratoryStatusInitial());

  final LaboratoriesRepo _laboratoriesRepo;

  bool get isBusy => state is LaboratoryStatusLoading;

  bool isBusyFor(int id) => switch (state) {
    LaboratoryStatusLoading(id: final int pending) => pending == id,
    _ => false,
  };

  Future<void> toggle(LaboratoryModel laboratory) async {
    if (isBusy) return;

    emit(LaboratoryStatusLoading(laboratory.id));

    final Result<LaboratoryModel> result = await _laboratoriesRepo
        .setLaboratoryActive(laboratory.id, !laboratory.isActive);

    if (isClosed) return;

    switch (result) {
      case Success<LaboratoryModel>(:final LaboratoryModel data):
        emit(LaboratoryStatusSuccess(data));
      case Failure<LaboratoryModel>(:final AppError error):
        emit(LaboratoryStatusFailure(error));
    }
  }

  void reset() {
    if (state is LaboratoryStatusInitial) return;
    emit(const LaboratoryStatusInitial());
  }
}
