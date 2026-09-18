import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/profile_model.dart';
import '../data/models/update_profile_request_body.dart';
import '../data/repos/profile_repo.dart';
part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit(this._profileRepo) : super(const UpdateProfileInitial());

  final ProfileRepo _profileRepo;

  final TextEditingController nameController = TextEditingController();

  bool get isBusy => state is UpdateProfileLoading;

  Future<void> save() async {
    if (isBusy) return;

    emit(const UpdateProfileLoading());

    final Result<ProfileModel> result = await _profileRepo.updateProfile(
      UpdateProfileRequestBody(name: nameController.text.trim()),
    );

    if (isClosed) return;

    switch (result) {
      case Success<ProfileModel>(:final ProfileModel data):
        nameController.text = data.name;
        emit(UpdateProfileSuccess(data));
      case Failure<ProfileModel>(:final AppError error):
        emit(UpdateProfileFailure(error));
    }
  }

  void dismissFeedback() {
    if (state is UpdateProfileSuccess || state is UpdateProfileFailure) {
      emit(const UpdateProfileInitial());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
