import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../../core/localization/app_locale.dart';
import '../data/models/create_laboratory_request_body.dart';
import '../data/repos/laboratories_repo.dart';
part 'create_laboratory_state.dart';

class CreateLaboratoryCubit extends Cubit<CreateLaboratoryState> {
  CreateLaboratoryCubit(this._laboratoriesRepo)
    : super(const CreateLaboratoryInitial());

  final LaboratoriesRepo _laboratoriesRepo;

  final TextEditingController nameController = TextEditingController();

  AppLocale _lang = AppLocale.en;

  AppLocale get lang => _lang;

  bool get isBusy => state is CreateLaboratoryLoading;

  void start(AppLocale lang) {
    nameController.clear();
    _lang = lang;
    emit(const CreateLaboratoryInitial());
  }

  void setLang(AppLocale lang) {
    if (lang == _lang) return;
    _lang = lang;
    _clearFailure();
    emit(CreateLaboratoryLangChanged(lang));
  }

  void nameEdited() => _clearFailure();

  Future<void> save() async {
    if (isBusy) return;

    emit(const CreateLaboratoryLoading());

    final Result<void> result = await _laboratoriesRepo.createLaboratory(
      CreateLaboratoryRequestBody(
        lang: _lang.code,
        name: nameController.text.trim(),
      ),
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const CreateLaboratorySuccess());
      case Failure<void>(:final AppError error):
        emit(CreateLaboratoryFailure(error));
    }
  }

  void dismissFailure() => _clearFailure();

  void _clearFailure() {
    if (state is CreateLaboratoryFailure) {
      emit(const CreateLaboratoryInitial());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
