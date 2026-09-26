import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/repos/laboratories_repo.dart';
part 'delete_laboratory_state.dart';

class DeleteLaboratoryCubit extends Cubit<DeleteLaboratoryState> {
  DeleteLaboratoryCubit(this._laboratoriesRepo)
    : super(const DeleteLaboratoryInitial());

  final LaboratoriesRepo _laboratoriesRepo;

  bool get isBusy => state is DeleteLaboratoryLoading;

  Future<void> delete(int id) async {
    if (isBusy) return;

    emit(const DeleteLaboratoryLoading());

    final Result<void> result = await _laboratoriesRepo.deleteLaboratory(id);

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const DeleteLaboratorySuccess());
      case Failure<void>(:final AppError error):
        emit(DeleteLaboratoryFailure(error));
    }
  }

  void dismissFailure() {
    if (state is DeleteLaboratoryFailure) {
      emit(const DeleteLaboratoryInitial());
    }
  }
}
