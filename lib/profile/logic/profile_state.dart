part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => <Object?>[];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(
    this.profile, {
    this.phoneTypes = const <PhoneTypeOption>[],
  });

  final ProfileModel profile;
  final List<PhoneTypeOption> phoneTypes;

  @override
  List<Object?> get props => <Object?>[
    profile.id,
    profile.name,
    profile.email,
    profile.phones,
    phoneTypes,
  ];
}

final class ProfileFailure extends ProfileState {
  const ProfileFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
