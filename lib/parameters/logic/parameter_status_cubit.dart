import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/parameter_model.dart';
import '../data/repos/parameters_repo.dart';
part 'parameter_status_state.dart';

class ParameterStatusCubit extends Cubit<ParameterStatusState> {
  ParameterStatusCubit(this._parametersRepo)
    : super(const ParameterStatusInitial());

  final ParametersRepo _parametersRepo;

  bool get isBusy => state is ParameterStatusLoading;

  bool isBusyFor(int id) => switch (state) {
    ParameterStatusLoading(id: final int pending) => pending == id,
    _ => false,
  };

  Future<void> toggle(ParameterModel parameter) async {
    if (isBusy) return;

    final bool active = !parameter.isActive;
    emit(ParameterStatusLoading(parameter.id));

    final Result<void> result = await _parametersRepo.setParameterActive(
      parameter.id,
      active,
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(ParameterStatusSuccess(parameter.withActive(active)));
      case Failure<void>(:final AppError error):
        emit(ParameterStatusFailure(error));
    }
  }

  void reset() {
    if (state is ParameterStatusInitial) return;
    emit(const ParameterStatusInitial());
  }
}
