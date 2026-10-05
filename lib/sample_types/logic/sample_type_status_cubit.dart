import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/sample_type_model.dart';
import '../data/repos/sample_types_repo.dart';
part 'sample_type_status_state.dart';

class SampleTypeStatusCubit extends Cubit<SampleTypeStatusState> {
  SampleTypeStatusCubit(this._sampleTypesRepo)
    : super(const SampleTypeStatusInitial());

  final SampleTypesRepo _sampleTypesRepo;

  bool get isBusy => state is SampleTypeStatusLoading;

  bool isBusyFor(int id) => switch (state) {
    SampleTypeStatusLoading(id: final int pending) => pending == id,
    _ => false,
  };

  Future<void> toggle(SampleTypeModel sampleType) async {
    if (isBusy) return;

    final bool active = !sampleType.isActive;
    emit(SampleTypeStatusLoading(sampleType.id));

    final Result<void> result = await _sampleTypesRepo.setSampleTypeActive(
      sampleType.id,
      active,
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(SampleTypeStatusSuccess(sampleType.withActive(active)));
      case Failure<void>(:final AppError error):
        emit(SampleTypeStatusFailure(error));
    }
  }

  void reset() {
    if (state is SampleTypeStatusInitial) return;
    emit(const SampleTypeStatusInitial());
  }
}
