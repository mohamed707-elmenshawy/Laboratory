import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/laboratory_model.dart';
import '../data/repos/laboratories_repo.dart';
part 'laboratory_details_state.dart';

class LaboratoryDetailsCubit extends Cubit<LaboratoryDetailsState> {
  LaboratoryDetailsCubit(this._laboratoriesRepo)
    : super(const LaboratoryDetailsInitial());

  final LaboratoriesRepo _laboratoriesRepo;

  int _id = 0;

  int get id => _id;

  Future<void> load(int id) async {
    if (state is LaboratoryDetailsLoading) return;

    _id = id;
    emit(const LaboratoryDetailsLoading());

    final Result<LaboratoryModel> result = await _laboratoriesRepo
        .fetchLaboratory(id);

    if (isClosed) return;

    switch (result) {
      case Success<LaboratoryModel>(:final LaboratoryModel data):
        emit(LaboratoryDetailsLoaded(data));
      case Failure<LaboratoryModel>(:final AppError error):
        emit(LaboratoryDetailsFailure(error));
    }
  }

  Future<void> reload() => load(_id);

  void laboratoryUpdated(LaboratoryModel laboratory) =>
      emit(LaboratoryDetailsLoaded(laboratory));
}
