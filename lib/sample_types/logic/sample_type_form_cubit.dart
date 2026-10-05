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
import '../data/models/sample_type_model.dart';
import '../data/models/sample_type_request_body.dart';
import '../data/repos/sample_types_repo.dart';
part 'sample_type_form_state.dart';

class SampleTypeFormCubit extends Cubit<SampleTypeFormState> {
  SampleTypeFormCubit(
    this._sampleTypesRepo,
    this._laboratoriesRepo,
    this._branchesRepo,
  ) : super(const SampleTypeFormInitial());

  static const int _branchPageSize = 100;

  final SampleTypesRepo _sampleTypesRepo;
  final LaboratoriesRepo _laboratoriesRepo;
  final BranchesRepo _branchesRepo;

  final TextEditingController nameController = TextEditingController();
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
  bool get isBusy => state is SampleTypeFormLoading;

  void startCreate(AppLocale lang) {
    _id = 0;
    _lang = lang;
    _laboratoryId = null;
    _branchId = null;
    _branches = const <BranchModel>[];
    nameController.clear();
    descriptionController.clear();
    emit(const SampleTypeFormInitial());
  }

  void seed(SampleTypeModel sampleType, AppLocale lang) {
    _id = sampleType.id;
    _lang = lang;
    _laboratoryId = sampleType.laboratory?.id;
    _branchId = sampleType.branch?.id;
    nameController.text = sampleType.name;
    descriptionController.text = sampleType.description ?? '';
    emit(const SampleTypeFormInitial());

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

    emit(const SampleTypeFormLoading());

    final SampleTypeRequestBody body = SampleTypeRequestBody(
      lang: _lang.code,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      laboratoryId: laboratoryId,
      branchId: branchId,
    );

    if (isCreating) {
      final Result<void> created = await _sampleTypesRepo.createSampleType(
        body,
      );

      if (isClosed) return;

      switch (created) {
        case Success<void>():
          emit(const SampleTypeFormCreated());
        case Failure<void>(:final AppError error):
          emit(SampleTypeFormFailure(error));
      }
      return;
    }

    final Result<void> result = await _sampleTypesRepo.updateSampleType(
      _id,
      body,
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const SampleTypeFormSaved());
      case Failure<void>(:final AppError error):
        emit(SampleTypeFormFailure(error));
    }
  }

  void dismissFailure() => _clearFailure();

  void _clearFailure() {
    if (state is SampleTypeFormFailure) _touch();
  }

  void _touch() => emit(SampleTypeFormEditing(++_revision));

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
