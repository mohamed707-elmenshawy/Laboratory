import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../branches/data/models/branch_model.dart';
import '../../branches/data/models/branches_page.dart';
import '../../branches/data/models/branches_query.dart';
import '../../branches/data/repos/branches_repo.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../../core/localization/app_locale.dart';
import '../../laboratories/data/models/laboratory_menu_item.dart';
import '../../laboratories/data/repos/laboratories_repo.dart';
import '../data/models/unit_model.dart';
import '../data/models/unit_request_body.dart';
import '../data/repos/units_repo.dart';
part 'unit_form_state.dart';

class UnitFormCubit extends Cubit<UnitFormState> {
  UnitFormCubit(this._unitsRepo, this._laboratoriesRepo, this._branchesRepo)
    : super(const UnitFormInitial());

  static const int _branchPageSize = 100;

  final UnitsRepo _unitsRepo;
  final LaboratoriesRepo _laboratoriesRepo;
  final BranchesRepo _branchesRepo;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController symbolController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  int _id = 0;
  int _revision = 0;
  AppLocale _lang = AppLocale.en;
  int? _laboratoryId;
  int? _branchId;
  bool _branchesLoading = false;

  List<LaboratoryMenuItem> _laboratories = const <LaboratoryMenuItem>[];
  List<BranchModel> _branches = const <BranchModel>[];

  AppLocale get lang => _lang;
  int? get laboratoryId => _laboratoryId;
  int? get branchId => _branchId;
  List<LaboratoryMenuItem> get laboratories => _laboratories;
  List<BranchModel> get branches => _branches;
  bool get branchesLoading => _branchesLoading;

  bool get isCreating => _id == 0;
  bool get isBusy => state is UnitFormLoading;

  void startCreate(AppLocale lang) {
    _id = 0;
    _lang = lang;
    _laboratoryId = null;
    _branchId = null;
    _branches = const <BranchModel>[];
    nameController.clear();
    symbolController.clear();
    descriptionController.clear();
    emit(const UnitFormInitial());
  }

  void seed(UnitModel unit, AppLocale lang) {
    _id = unit.id;
    _lang = lang;
    _laboratoryId = unit.laboratory?.id;
    _branchId = unit.branch?.id;
    nameController.text = unit.name;
    symbolController.text = unit.symbol;
    descriptionController.text = unit.description ?? '';
    emit(const UnitFormInitial());

    if (_laboratoryId != null) loadBranches(_laboratoryId!);
  }

  Future<void> loadLaboratories() async {
    if (_laboratories.isNotEmpty) return;

    final Result<List<LaboratoryMenuItem>> result = await _laboratoriesRepo
        .fetchLaboratoriesMenu();

    if (isClosed) return;

    if (result case Success<List<LaboratoryMenuItem>>(
      :final List<LaboratoryMenuItem> data,
    )) {
      _laboratories = data;
      _touch();
    }
  }

  Future<void> loadBranches(int laboratoryId) async {
    _branchesLoading = true;
    _touch();

    final Result<BranchesPage> result = await _branchesRepo.fetchBranches(
      BranchesQuery(
        page: 1,
        perPage: _branchPageSize,
        status: BranchStatusFilter.active,
        laboratoryId: laboratoryId,
      ),
    );

    if (isClosed) return;

    _branchesLoading = false;

    _branches = switch (result) {
      Success<BranchesPage>(:final BranchesPage data) => data.items,
      Failure<BranchesPage>() => const <BranchModel>[],
    };

    if (!_branches.any((BranchModel branch) => branch.id == _branchId)) {
      _branchId = null;
    }

    _touch();
  }

  void setLang(AppLocale lang) {
    if (lang == _lang) return;
    _lang = lang;
    _clearFailure();
    _touch();
  }

  void setLaboratory(int laboratoryId) {
    if (laboratoryId == _laboratoryId) return;

    _laboratoryId = laboratoryId;
    _branchId = null;
    _branches = const <BranchModel>[];
    _clearFailure();
    _touch();
    loadBranches(laboratoryId);
  }

  void setBranch(int branchId) {
    if (branchId == _branchId) return;
    _branchId = branchId;
    _clearFailure();
    _touch();
  }

  void fieldEdited() => _clearFailure();

  Future<void> save() async {
    if (isBusy) return;

    final int? laboratoryId = _laboratoryId;
    final int? branchId = _branchId;
    if (laboratoryId == null || branchId == null) return;

    emit(const UnitFormLoading());

    final UnitRequestBody body = UnitRequestBody(
      lang: _lang.code,
      name: nameController.text.trim(),
      symbol: symbolController.text.trim(),
      description: descriptionController.text.trim(),
      laboratoryId: laboratoryId,
      branchId: branchId,
    );

    if (isCreating) {
      final Result<void> created = await _unitsRepo.createUnit(body);

      if (isClosed) return;

      switch (created) {
        case Success<void>():
          emit(const UnitFormCreated());
        case Failure<void>(:final AppError error):
          emit(UnitFormFailure(error));
      }
      return;
    }

    final Result<void> result = await _unitsRepo.updateUnit(_id, body);

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const UnitFormSaved());
      case Failure<void>(:final AppError error):
        emit(UnitFormFailure(error));
    }
  }

  void dismissFailure() => _clearFailure();

  void _clearFailure() {
    if (state is UnitFormFailure) _touch();
  }

  void _touch() => emit(UnitFormEditing(++_revision));

  @override
  Future<void> close() {
    nameController.dispose();
    symbolController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
