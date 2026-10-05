import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/sample_type_model.dart';
import '../data/repos/sample_types_repo.dart';
part 'sample_type_details_state.dart';

class SampleTypeDetailsCubit extends Cubit<SampleTypeDetailsState> {
  SampleTypeDetailsCubit(this._sampleTypesRepo)
    : super(const SampleTypeDetailsInitial());

  final SampleTypesRepo _sampleTypesRepo;

  int _id = 0;

  int get id => _id;

  Future<void> load(int id) async {
    if (state is SampleTypeDetailsLoading) return;

    _id = id;
    emit(const SampleTypeDetailsLoading());

    final Result<SampleTypeModel> result = await _sampleTypesRepo
        .fetchSampleType(id);

    if (isClosed) return;

    switch (result) {
      case Success<SampleTypeModel>(:final SampleTypeModel data):
        emit(SampleTypeDetailsLoaded(data));
      case Failure<SampleTypeModel>(:final AppError error):
        emit(SampleTypeDetailsFailure(error));
    }
  }

  Future<void> reload() => load(_id);

  void sampleTypeUpdated(SampleTypeModel sampleType) =>
      emit(SampleTypeDetailsLoaded(sampleType));
}
