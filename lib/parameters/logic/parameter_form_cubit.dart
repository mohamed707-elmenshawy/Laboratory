import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../branches/data/models/branch_menu_item.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../../core/localization/app_locale.dart';
import '../../laboratories/data/models/laboratory_menu_item.dart';
import '../../laboratories/data/repos/laboratories_repo.dart';
import '../data/models/parameter_model.dart';
import '../data/models/parameter_request_body.dart';
import '../data/repos/parameters_repo.dart';
part 'parameter_form_state.dart';

class ParameterFormCubit extends Cubit<ParameterFormState> {
  ParameterFormCubit(this._parametersRepo, this._laboratoriesRepo)
    : super(const ParameterFormInitial());

  final ParametersRepo _parametersRepo;
  final LaboratoriesRepo _laboratoriesRepo;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  int _id = 0;
  int _revision = 0;
  AppLocale _lang = AppLocale.en;
  int? _laboratoryId;
  int? _branchId;
  bool _branchesLoading = false;

  List<LaboratoryMenuItem> _laboratories = const <LaboratoryMenuItem>[];
  List<BranchMenuItem> _branches = const <BranchMenuItem>[];

  AppLocale get lang => _lang;
  int? get laboratoryId => _laboratoryId;
  int? get branchId => _branchId;
  List<LaboratoryMenuItem> get laboratories => _laboratories;
  List<BranchMenuItem> get branches => _branches;
  bool get branchesLoading => _branchesLoading;

  bool get isCreating => _id == 0;
  bool get isBusy => state is ParameterFormLoading;

  void startCreate(AppLocale lang) {
    _id = 0;
    _lang = lang;
    _laboratoryId = null;
    _branchId = null;
    _branches = const <BranchMenuItem>[];
    _branchesLoading = false;
    nameController.clear();
    descriptionController.clear();
    emit(const ParameterFormInitial());
  }

  void seed(ParameterModel parameter, AppLocale lang) {
    _id = parameter.id;
    _lang = lang;
    _laboratoryId = parameter.laboratory?.id;
    _branchId = parameter.branch?.id;
    nameController.text = parameter.name;
    descriptionController.text = parameter.description ?? '';
    emit(const ParameterFormInitial());

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

    final Result<List<BranchMenuItem>> result = await _laboratoriesRepo
        .fetchLaboratoryBranches(laboratoryId);

    if (isClosed || laboratoryId != _laboratoryId) return;

    _branchesLoading = false;

    _branches = switch (result) {
      Success<List<BranchMenuItem>>(:final List<BranchMenuItem> data) => data,
      Failure<List<BranchMenuItem>>() => const <BranchMenuItem>[],
    };

    if (!_branches.any((BranchMenuItem branch) => branch.id == _branchId)) {
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
    _branches = const <BranchMenuItem>[];
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

    emit(const ParameterFormLoading());

    final ParameterRequestBody body = ParameterRequestBody(
      lang: _lang.code,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      laboratoryId: laboratoryId,
      branchId: branchId,
    );

    if (isCreating) {
      final Result<void> created = await _parametersRepo.createParameter(body);

      if (isClosed) return;

      switch (created) {
        case Success<void>():
          emit(const ParameterFormCreated());
        case Failure<void>(:final AppError error):
          emit(ParameterFormFailure(error));
      }
      return;
    }

    final Result<void> result = await _parametersRepo.updateParameter(
      _id,
      body,
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const ParameterFormSaved());
      case Failure<void>(:final AppError error):
        emit(ParameterFormFailure(error));
    }
  }

  void dismissFailure() => _clearFailure();

  void _clearFailure() {
    if (state is ParameterFormFailure) _touch();
  }

  void _touch() => emit(ParameterFormEditing(++_revision));

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
