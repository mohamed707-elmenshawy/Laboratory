import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/parameter_model.dart';
import '../data/repos/parameters_repo.dart';
part 'parameter_details_state.dart';

class ParameterDetailsCubit extends Cubit<ParameterDetailsState> {
  ParameterDetailsCubit(this._parametersRepo)
    : super(const ParameterDetailsInitial());

  final ParametersRepo _parametersRepo;

  int _id = 0;

  int get id => _id;

  Future<void> load(int id) async {
    if (state is ParameterDetailsLoading) return;

    _id = id;
    emit(const ParameterDetailsLoading());

    final Result<ParameterModel> result = await _parametersRepo.fetchParameter(
      id,
    );

    if (isClosed) return;

    switch (result) {
      case Success<ParameterModel>(:final ParameterModel data):
        emit(ParameterDetailsLoaded(data));
      case Failure<ParameterModel>(:final AppError error):
        emit(ParameterDetailsFailure(error));
    }
  }

  Future<void> reload() => load(_id);

  void parameterUpdated(ParameterModel parameter) =>
      emit(ParameterDetailsLoaded(parameter));
}
