import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/repos/sample_types_repo.dart';
part 'delete_sample_type_state.dart';

class DeleteSampleTypeCubit extends Cubit<DeleteSampleTypeState> {
  DeleteSampleTypeCubit(this._sampleTypesRepo)
    : super(const DeleteSampleTypeInitial());

  final SampleTypesRepo _sampleTypesRepo;

  bool get isBusy => state is DeleteSampleTypeLoading;

  Future<void> delete(int id) async {
    if (isBusy) return;

    emit(const DeleteSampleTypeLoading());

    final Result<void> result = await _sampleTypesRepo.deleteSampleType(id);

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const DeleteSampleTypeSuccess());
      case Failure<void>(:final AppError error):
        emit(DeleteSampleTypeFailure(error));
    }
  }

  void dismissFailure() {
    if (state is DeleteSampleTypeFailure) {
      emit(const DeleteSampleTypeInitial());
    }
  }
}
