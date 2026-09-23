import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/result.dart';
import '../../core/models/lab_settings.dart';
import '../data/repos/settings_repo.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repo) : super(const SettingsInitial()) {
    load();
  }

  final SettingsRepo _repo;

  LabSettings get settings => switch (state) {
    SettingsLoaded(:final LabSettings settings) => settings,
    _ => LabSettings.fallback,
  };

  Future<void> load() async {
    if (state is SettingsLoading || state is SettingsLoaded) return;

    emit(const SettingsLoading());

    final Result<LabSettings> result = await _repo.fetchSettings();
    if (isClosed) return;

    switch (result) {
      case Success<LabSettings>(:final LabSettings data):
        emit(SettingsLoaded(data));
      case Failure<LabSettings>():
        emit(const SettingsLoaded(LabSettings.fallback));
    }
  }
}
