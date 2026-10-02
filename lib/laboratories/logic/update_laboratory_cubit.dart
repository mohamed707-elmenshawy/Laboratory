import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../../core/localization/app_locale.dart';
import '../data/models/laboratory_model.dart';
import '../data/models/update_laboratory_request_body.dart';
import '../data/repos/laboratories_repo.dart';

part 'update_laboratory_state.dart';

class UpdateLaboratoryCubit extends Cubit<UpdateLaboratoryState> {
  UpdateLaboratoryCubit(this._laboratoriesRepo)
    : super(const UpdateLaboratoryInitial());

  final LaboratoriesRepo _laboratoriesRepo;

  final TextEditingController nameController = TextEditingController();

  int _id = 0;
  int _revision = 0;
  AppLocale _lang = AppLocale.en;
  String? _currentLogoUrl;
  LaboratoryLogoFile? _logo;
  String? _logoError;

  AppLocale get lang => _lang;
  String? get currentLogoUrl => _currentLogoUrl;
  LaboratoryLogoFile? get logo => _logo;
  String? get logoError => _logoError;

  bool get isBusy => state is UpdateLaboratoryLoading;

  void seed(LaboratoryModel laboratory, AppLocale lang) {
    _id = laboratory.id;
    _lang = lang;
    _currentLogoUrl = laboratory.logoUrl;
    _logo = null;
    _logoError = null;
    nameController.text = laboratory.name;
    emit(const UpdateLaboratoryInitial());
  }

  void setLang(AppLocale lang) {
    if (lang == _lang) return;
    _lang = lang;
    _clearFailure();
    _touch();
  }

  void setLogo(LaboratoryLogoFile logo) {
    _logo = logo;
    _logoError = null;
    _clearFailure();
    _touch();
  }

  void logoRejected(String message) {
    _logo = null;
    _logoError = message;
    _touch();
  }

  void clearLogo() {
    if (_logo == null && _logoError == null) return;
    _logo = null;
    _logoError = null;
    _clearFailure();
    _touch();
  }

  void nameEdited() => _clearFailure();

  Future<void> save() async {
    if (isBusy || _id == 0) return;

    emit(const UpdateLaboratoryLoading());

    final Result<LaboratoryModel> result = await _laboratoriesRepo
        .updateLaboratory(
          _id,
          UpdateLaboratoryRequestBody(
            lang: _lang.code,
            name: nameController.text.trim(),
            logo: _logo,
          ),
        );

    if (isClosed) return;

    switch (result) {
      case Success<LaboratoryModel>(:final LaboratoryModel data):
        emit(UpdateLaboratorySuccess(data));
      case Failure<LaboratoryModel>(:final AppError error):
        emit(UpdateLaboratoryFailure(error));
    }
  }

  void dismissFailure() => _clearFailure();

  void _clearFailure() {
    if (state is UpdateLaboratoryFailure) _touch();
  }

  void _touch() => emit(UpdateLaboratoryEditing(++_revision));

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
