import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/unit_model.dart';
import '../data/repos/units_repo.dart';
part 'unit_status_state.dart';

class UnitStatusCubit extends Cubit<UnitStatusState> {
  UnitStatusCubit(this._unitsRepo) : super(const UnitStatusInitial());

  final UnitsRepo _unitsRepo;

  bool get isBusy => state is UnitStatusLoading;

  bool isBusyFor(int id) => switch (state) {
    UnitStatusLoading(id: final int pending) => pending == id,
    _ => false,
  };

  Future<void> toggle(UnitModel unit) async {
    if (isBusy) return;

    final bool active = !unit.isActive;
    emit(UnitStatusLoading(unit.id));

    final Result<void> result = await _unitsRepo.setUnitActive(unit.id, active);

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(UnitStatusSuccess(unit.withActive(active)));
      case Failure<void>(:final AppError error):
        emit(UnitStatusFailure(error));
    }
  }

  void reset() {
    if (state is UnitStatusInitial) return;
    emit(const UnitStatusInitial());
  }
}
