import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../../core/localization/app_locale.dart';
import '../../core/phones/phones.dart';
import '../../laboratories/data/models/laboratory_menu_item.dart';
import '../../laboratories/data/repos/laboratories_repo.dart';
import '../data/models/branch_model.dart';
import '../data/models/update_branch_request_body.dart';
import '../data/repos/branches_repo.dart';
part 'update_branch_state.dart';

class UpdateBranchCubit extends Cubit<UpdateBranchState> {
  UpdateBranchCubit(this._branchesRepo, this._laboratoriesRepo)
    : super(const UpdateBranchInitial());

  static const int maxPhones = 5;

  final BranchesRepo _branchesRepo;
  final LaboratoriesRepo _laboratoriesRepo;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ValueNotifier<List<PhoneDraft>> phones =
      ValueNotifier<List<PhoneDraft>>(<PhoneDraft>[]);

  final List<PhoneDraft> _retired = <PhoneDraft>[];

  int _id = 0;
  AppLocale _lang = AppLocale.en;
  int? _laboratoryId;
  bool _isMainBranch = false;
  int _revision = 0;

  List<LaboratoryMenuItem> _laboratories = const <LaboratoryMenuItem>[];

  AppLocale get lang => _lang;
  int? get laboratoryId => _laboratoryId;
  bool get isMainBranch => _isMainBranch;
  List<LaboratoryMenuItem> get laboratories => _laboratories;

  bool get isBusy => state is UpdateBranchLoading;
  bool get canAddPhone => phones.value.length < maxPhones;

  bool get isCreating => _id == 0;

  void seedNew(AppLocale lang) {
    _id = 0;
    _lang = lang;
    _laboratoryId = null;
    _isMainBranch = false;

    nameController.clear();
    addressController.clear();

    _retired.addAll(phones.value);
    phones.value = <PhoneDraft>[];

    emit(const UpdateBranchInitial());
  }

  void seed(BranchModel branch, AppLocale lang) {
    _id = branch.id;
    _lang = lang;
    _laboratoryId = branch.laboratory?.id;
    _isMainBranch = branch.isMainBranch;

    nameController.text = branch.name;
    addressController.text = branch.address ?? '';

    _retired.addAll(phones.value);
    phones.value = branch.phones
        .map(
          (PhoneModel phone) => PhoneDraft(
            id: phone.id == 0 ? null : phone.id,
            phone: phone.phone,
            country: phone.phoneCountry,
            type: phone.type,
            dialCode: phone.dialCode,
          ),
        )
        .toList(growable: false);

    emit(const UpdateBranchInitial());
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

  void setLang(AppLocale lang) {
    if (lang == _lang) return;
    _lang = lang;
    _touch();
  }

  void setLaboratory(int laboratoryId) {
    if (laboratoryId == _laboratoryId) return;
    _laboratoryId = laboratoryId;
    _touch();
  }

  void setMainBranch(bool value) {
    if (value == _isMainBranch) return;
    _isMainBranch = value;
    _touch();
  }

  void addPhone() {
    if (!canAddPhone) return;
    _clearFailure();
    phones.value = <PhoneDraft>[...phones.value, PhoneDraft()];
  }

  void removePhone(PhoneDraft phone) {
    if (!phones.value.contains(phone)) return;

    _clearFailure();
    phones.value = phones.value
        .where((PhoneDraft draft) => draft != phone)
        .toList(growable: false);
    _retired.add(phone);
  }

  void setPhoneCountry(PhoneDraft phone, String country) {
    if (phone.country == country) return;
    phone.country = country;
    _clearFailure();
    phones.value = List<PhoneDraft>.of(phones.value);
  }

  void setPhoneType(PhoneDraft phone, String type) {
    if (phone.type == type) return;
    phone.type = type;
    _clearFailure();
    phones.value = List<PhoneDraft>.of(phones.value);
  }

  void fieldEdited() => _clearFailure();

  String? duplicatePhone(PhoneDraft phone) {
    final String value = phone.phone;
    if (value.isEmpty) return null;

    for (final PhoneDraft other in phones.value) {
      if (identical(other, phone)) break;
      if (other.phone == value) return value;
    }
    return null;
  }

  Future<void> save() async {
    if (isBusy) return;

    final int? laboratoryId = _laboratoryId;
    if (laboratoryId == null) return;

    emit(const UpdateBranchLoading());

    final UpdateBranchRequestBody body = UpdateBranchRequestBody(
      lang: _lang.code,
      name: nameController.text.trim(),
      laboratoryId: laboratoryId,
      isMainBranch: _isMainBranch,
      address: addressController.text.trim(),
      phones: phones.value
          .where((PhoneDraft phone) => !phone.isEmpty)
          .map((PhoneDraft phone) => phone.toPayload())
          .toList(growable: false),
    );

    if (isCreating) {
      final Result<void> created = await _branchesRepo.createBranch(body);

      if (isClosed) return;

      switch (created) {
        case Success<void>():
          emit(const UpdateBranchCreated());
        case Failure<void>(:final AppError error):
          emit(UpdateBranchFailure(error));
      }
      return;
    }

    final Result<BranchModel> result = await _branchesRepo.updateBranch(
      _id,
      body,
    );

    if (isClosed) return;

    switch (result) {
      case Success<BranchModel>(:final BranchModel data):
        emit(UpdateBranchSuccess(data));
      case Failure<BranchModel>(:final AppError error):
        emit(UpdateBranchFailure(error));
    }
  }

  void dismissFailure() => _clearFailure();

  void _clearFailure() {
    if (state is UpdateBranchFailure) _touch();
  }

  void _touch() => emit(UpdateBranchEditing(++_revision));

  @override
  Future<void> close() {
    nameController.dispose();
    addressController.dispose();
    for (final PhoneDraft draft in <PhoneDraft>[...phones.value, ..._retired]) {
      draft.dispose();
    }
    phones.dispose();
    return super.close();
  }
}
