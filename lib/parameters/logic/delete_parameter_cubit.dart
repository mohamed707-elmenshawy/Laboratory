import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/repos/parameters_repo.dart';
part 'delete_parameter_state.dart';

class DeleteParameterCubit extends Cubit<DeleteParameterState> {
  DeleteParameterCubit(this._parametersRepo)
    : super(const DeleteParameterInitial());

  final ParametersRepo _parametersRepo;

  bool get isBusy => state is DeleteParameterLoading;

  Future<void> delete(int id) async {
    if (isBusy) return;

    emit(const DeleteParameterLoading());

    final Result<void> result = await _parametersRepo.deleteParameter(id);

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const DeleteParameterSuccess());
      case Failure<void>(:final AppError error):
        emit(DeleteParameterFailure(error));
    }
  }

  void dismissFailure() {
    if (state is DeleteParameterFailure) {
      emit(const DeleteParameterInitial());
    }
  }
}
