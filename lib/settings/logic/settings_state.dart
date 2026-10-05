part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  /// The app does not wait on these: until they load, or if they fail, it
  /// runs on [LabSettings.fallback].
  LabSettings get settings => LabSettings.fallback;

  @override
  List<Object?> get props => <Object?>[];
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

final class SettingsLoaded extends SettingsState {
  const SettingsLoaded(this.settings);

  @override
  final LabSettings settings;

  @override
  List<Object?> get props => <Object?>[settings];
}

final class SettingsFailure extends SettingsState {
  const SettingsFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
