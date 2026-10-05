import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/unit_model.dart';
import '../data/repos/units_repo.dart';
part 'unit_details_state.dart';

class UnitDetailsCubit extends Cubit<UnitDetailsState> {
  UnitDetailsCubit(this._unitsRepo) : super(const UnitDetailsInitial());

  final UnitsRepo _unitsRepo;

  int _id = 0;

  int get id => _id;

  Future<void> load(int id) async {
    if (state is UnitDetailsLoading) return;

    _id = id;
    emit(const UnitDetailsLoading());

    final Result<UnitModel> result = await _unitsRepo.fetchUnit(id);

    if (isClosed) return;

    switch (result) {
      case Success<UnitModel>(:final UnitModel data):
        emit(UnitDetailsLoaded(data));
      case Failure<UnitModel>(:final AppError error):
        emit(UnitDetailsFailure(error));
    }
  }

  Future<void> reload() => load(_id);

  void unitUpdated(UnitModel unit) => emit(UnitDetailsLoaded(unit));
}
