part of 'update_profile_cubit.dart';

sealed class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object?> get props => <Object?>[];
}

final class UpdateProfileInitial extends UpdateProfileState {
  const UpdateProfileInitial();
}

final class UpdateProfileLoading extends UpdateProfileState {
  const UpdateProfileLoading();
}

final class UpdateProfileSuccess extends UpdateProfileState {
  const UpdateProfileSuccess(this.profile);

  final ProfileModel profile;

  @override
  List<Object?> get props => <Object?>[profile.id, profile.name];
}

final class UpdateProfileFailure extends UpdateProfileState {
  const UpdateProfileFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
