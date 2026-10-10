import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../branches/data/models/branch_menu_item.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../../core/phones/phones.dart';
import '../../laboratories/data/models/laboratory_menu_item.dart';
import '../../laboratories/data/repos/laboratories_repo.dart';
import '../../profile/data/models/profile_model.dart';
import '../../profile/data/repos/profile_repo.dart';
import '../data/models/role_model.dart';
import '../data/models/user_model.dart';
import '../data/models/user_request_body.dart';
import '../data/repos/users_repo.dart';
part 'user_form_state.dart';

class UserFormCubit extends Cubit<UserFormState> {
  UserFormCubit(this._usersRepo, this._laboratoriesRepo, this._profileRepo)
    : super(const UserFormInitial());

  static const int maxPhones = 5;

  final UsersRepo _usersRepo;
  final LaboratoriesRepo _laboratoriesRepo;
  final ProfileRepo _profileRepo;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController commissionController = TextEditingController();

  final ValueNotifier<List<PhoneDraft>> phones =
      ValueNotifier<List<PhoneDraft>>(<PhoneDraft>[]);

  final List<PhoneDraft> _retired = <PhoneDraft>[];

  int _id = 0;
  int _revision = 0;
  List<String> _roles = const <String>[];
  int? _laboratoryId;
  int? _branchId;
  bool _branchesLoading = false;

  List<RoleModel> _catalogue = const <RoleModel>[];
  List<String> _grantable = const <String>[];
  List<String> _permissions = const <String>[];
  bool _permissionsTouched = false;
  bool _grantableLoading = false;
  bool _grantableFailed = false;
  List<LaboratoryMenuItem> _laboratories = const <LaboratoryMenuItem>[];
  List<BranchMenuItem> _branches = const <BranchMenuItem>[];
  List<PhoneTypeOption> _phoneTypes = const <PhoneTypeOption>[];

  List<String> get roles => _roles;
  int? get laboratoryId => _laboratoryId;
  int? get branchId => _branchId;
  List<RoleModel> get catalogue => _catalogue;
  List<String> get grantablePermissions => _grantable;
  List<String> get permissions => _permissions;
  bool get grantableLoading => _grantableLoading;
  bool get grantableFailed => _grantableFailed;
  List<LaboratoryMenuItem> get laboratories => _laboratories;
  List<BranchMenuItem> get branches => _branches;
  List<PhoneTypeOption> get phoneTypes => _phoneTypes;
  bool get branchesLoading => _branchesLoading;

  bool get isCreating => _id == 0;
  bool get isBusy => state is UserFormLoading;
  bool get canAddPhone => phones.value.length < maxPhones;

  RoleScope get scope =>
      _roles.isEmpty ? RoleScope.unknown : RoleScope.of(_roles.first);

  bool get needsLaboratory => scope.needsLaboratory;
  bool get needsBranch => scope.needsBranch;
  bool get needsCommission => _roles.contains('team-member');

  bool get isReady {
    if (_roles.isEmpty) return false;
    if (needsLaboratory && _laboratoryId == null) return false;
    if (needsBranch && _branchId == null) return false;
    return true;
  }

  void startCreate() {
    _id = 0;
    _roles = const <String>[];
    _laboratoryId = null;
    _branchId = null;
    _branches = const <BranchMenuItem>[];
    _permissions = const <String>[];
    _permissionsTouched = false;

    nameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    commissionController.clear();

    _retired.addAll(phones.value);
    phones.value = <PhoneDraft>[];

    emit(const UserFormInitial());
  }

  void seed(UserModel user) {
    _id = user.id;
    _roles = List<String>.of(user.roles);
    _laboratoryId = user.laboratory?.id;
    _branchId = user.branch?.id;
    _permissions = const <String>[];
    _permissionsTouched = false;

    nameController.text = user.name;
    emailController.text = user.email;
    passwordController.clear();
    passwordConfirmationController.clear();
    commissionController.text = user.commissionPercentage == null
        ? ''
        : _trimDecimal(user.commissionPercentage!);

    _retired.addAll(phones.value);
    phones.value = user.phones
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

    emit(const UserFormInitial());

    if (_laboratoryId != null) loadBranches(_laboratoryId!);
  }

  Future<void> loadCatalogue() async {
    await Future.wait<void>(<Future<void>>[
      _loadRoles(),
      _loadLaboratories(),
      _loadPhoneTypes(),
      loadGrantablePermissions(),
    ]);
  }

  Future<void> loadGrantablePermissions() async {
    if (_grantable.isNotEmpty || _grantableLoading) return;

    _grantableLoading = true;
    _grantableFailed = false;
    _touch();

    final Result<ProfileModel> result = await _profileRepo.fetchProfile();

    if (isClosed) return;

    _grantableLoading = false;

    switch (result) {
      case Success<ProfileModel>(:final ProfileModel data):
        _grantable = List<String>.of(data.permissions)..sort();
      case Failure<ProfileModel>():
        _grantableFailed = true;
    }

    _touch();
  }

  void togglePermission(String permission) {
    if (!_grantable.contains(permission)) return;

    _permissionsTouched = true;
    _permissions = _permissions.contains(permission)
        ? _permissions
              .where((String item) => item != permission)
              .toList(growable: false)
        : <String>[..._permissions, permission];

    _clearFailure();
    _touch();
  }

  void togglePermissionGroup(List<String> group, bool selected) {
    _permissionsTouched = true;

    final Set<String> next = <String>{..._permissions};
    if (selected) {
      next.addAll(group.where(_grantable.contains));
    } else {
      next.removeAll(group);
    }

    _permissions = next.toList(growable: false)..sort();
    _clearFailure();
    _touch();
  }

  void clearPermissions() {
    if (_permissions.isEmpty) return;

    _permissionsTouched = true;
    _permissions = const <String>[];
    _clearFailure();
    _touch();
  }

  Future<void> _loadRoles() async {
    if (_catalogue.isNotEmpty) return;

    final Result<List<RoleModel>> result = await _usersRepo.fetchRoles();

    if (isClosed) return;

    if (result case Success<List<RoleModel>>(:final List<RoleModel> data)) {
      _catalogue = data;
      _touch();
    }
  }

  Future<void> _loadLaboratories() async {
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

  Future<void> _loadPhoneTypes() async {
    if (_phoneTypes.isNotEmpty) return;

    final Result<List<PhoneTypeOption>> result = await _profileRepo
        .fetchPhoneTypes();

    if (isClosed) return;

    if (result case Success<List<PhoneTypeOption>>(
      :final List<PhoneTypeOption> data,
    )) {
      _phoneTypes = data;
      _touch();
    }
  }

  Future<void> loadBranches(int laboratoryId) async {
    _branchesLoading = true;
    _touch();

    final Result<List<BranchMenuItem>> result = await _laboratoriesRepo
        .fetchLaboratoryBranches(laboratoryId);

    if (isClosed) return;

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

  void toggleRole(RoleModel role) {
    _clearFailure();

    if (_roles.contains(role.name)) {
      _roles = _roles
          .where((String name) => name != role.name)
          .toList(growable: false);
      _applyScope();
      _touch();
      return;
    }

    final RoleScope next = role.scope;
    final bool keeps =
        !role.isExclusive &&
        _roles.isNotEmpty &&
        scope == next &&
        !_roles.any(
          (String name) => _catalogue
              .where((RoleModel item) => item.name == name)
              .any((RoleModel item) => item.isExclusive),
        );

    _roles = keeps ? <String>[..._roles, role.name] : <String>[role.name];

    _applyScope();
    _touch();
  }

  void setLaboratory(int laboratoryId) {
    if (laboratoryId == _laboratoryId) return;

    _laboratoryId = laboratoryId;
    _branchId = null;
    _branches = const <BranchMenuItem>[];
    _clearFailure();
    _touch();

    if (needsBranch) loadBranches(laboratoryId);
  }

  void setBranch(int branchId) {
    if (branchId == _branchId) return;
    _branchId = branchId;
    _clearFailure();
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

  String? duplicatePhone(PhoneDraft phone) {
    final String value = phone.phone;
    if (value.isEmpty) return null;

    for (final PhoneDraft other in phones.value) {
      if (identical(other, phone)) break;
      if (other.phone == value) return value;
    }
    return null;
  }

  void fieldEdited() => _clearFailure();

  Future<void> save() async {
    if (isBusy || !isReady) return;

    emit(const UserFormLoading());

    final UserRequestBody body = UserRequestBody(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      passwordConfirmation: passwordConfirmationController.text,
      roles: _roles,
      laboratoryId: needsLaboratory ? _laboratoryId : null,
      branchId: needsBranch ? _branchId : null,
      commissionPercentage: needsCommission
          ? double.tryParse(commissionController.text.trim())
          : null,
      permissions: needsCommission ? const <String>[] : _permissions,
      sendPermissions: _permissionsTouched || _permissions.isNotEmpty,
      phones: phones.value
          .where((PhoneDraft phone) => !phone.isEmpty)
          .map((PhoneDraft phone) => phone.toPayload())
          .toList(growable: false),
    );

    final Result<void> result = isCreating
        ? await _usersRepo.createUser(body)
        : await _usersRepo.updateUser(_id, body);

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(isCreating ? const UserFormCreated() : const UserFormSaved());
      case Failure<void>(:final AppError error):
        emit(UserFormFailure(error));
    }
  }

  void dismissFailure() => _clearFailure();

  void _applyScope() {
    if (!needsLaboratory) {
      _laboratoryId = null;
      _branches = const <BranchMenuItem>[];
    }

    if (!needsBranch) _branchId = null;

    if (!needsCommission) commissionController.clear();

    if (needsCommission && _permissions.isNotEmpty) {
      _permissions = const <String>[];
      _permissionsTouched = true;
    }

    if (needsBranch && _laboratoryId != null && _branches.isEmpty) {
      loadBranches(_laboratoryId!);
    }
  }

  void _clearFailure() {
    if (state is UserFormFailure) _touch();
  }

  void _touch() => emit(UserFormEditing(++_revision));

  static String _trimDecimal(double value) {
    final String text = value.toStringAsFixed(2);
    if (!text.contains('.')) return text;

    return text.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    commissionController.dispose();
    for (final PhoneDraft draft in <PhoneDraft>[...phones.value, ..._retired]) {
      draft.dispose();
    }
    phones.dispose();
    return super.close();
  }
}
