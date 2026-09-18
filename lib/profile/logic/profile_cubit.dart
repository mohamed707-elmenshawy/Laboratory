import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/profile_model.dart';
import '../data/repos/profile_repo.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._profileRepo) : super(const ProfileInitial());

  final ProfileRepo _profileRepo;

  Future<void> loadProfile() async {
    if (state is ProfileLoading) return;

    emit(const ProfileLoading());

    final Result<ProfileModel> result = await _profileRepo.fetchProfile();

    if (isClosed) return;

    switch (result) {
      case Success<ProfileModel>(:final ProfileModel data):
        emit(ProfileLoaded(data));
      case Failure<ProfileModel>(:final AppError error):
        emit(ProfileFailure(error));
    }
  }

  void profileUpdated(ProfileModel profile) => emit(ProfileLoaded(profile));
}
