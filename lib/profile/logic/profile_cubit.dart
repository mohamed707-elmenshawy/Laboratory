import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/phone_type_option.dart';
import '../data/models/profile_model.dart';
import '../data/repos/profile_repo.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._profileRepo) : super(const ProfileInitial());

  final ProfileRepo _profileRepo;

  List<PhoneTypeOption> _phoneTypes = const <PhoneTypeOption>[];

  Future<void> loadProfile() async {
    if (state is ProfileLoading) return;

    emit(const ProfileLoading());

    final Result<ProfileModel> result = await _profileRepo.fetchProfile();

    if (isClosed) return;

    switch (result) {
      case Success<ProfileModel>(:final ProfileModel data):
        await _loadPhoneTypes();
        if (isClosed) return;
        emit(ProfileLoaded(data, phoneTypes: _phoneTypes));
      case Failure<ProfileModel>(:final AppError error):
        emit(ProfileFailure(error));
    }
  }

  Future<void> localeChanged() async {
    if (state is! ProfileLoaded) return;

    _phoneTypes = const <PhoneTypeOption>[];
    await _loadPhoneTypes();

    if (isClosed) return;
    if (state case ProfileLoaded(:final ProfileModel profile)) {
      emit(ProfileLoaded(profile, phoneTypes: _phoneTypes));
    }
  }

  Future<void> _loadPhoneTypes() async {
    if (_phoneTypes.isNotEmpty) return;

    final Result<List<PhoneTypeOption>> result = await _profileRepo
        .fetchPhoneTypes();

    if (result case Success<List<PhoneTypeOption>>(
      :final List<PhoneTypeOption> data,
    )) {
      _phoneTypes = data;
    }
  }

  void profileUpdated(ProfileModel profile) =>
      emit(ProfileLoaded(profile, phoneTypes: _phoneTypes));
}
