import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/app_locale.dart';
import 'package:laboratory/core/models/lab_settings.dart';
import 'package:laboratory/core/networking/api_client.dart';
import 'package:laboratory/core/networking/api_constants.dart';
import 'package:laboratory/settings/data/repos/settings_repo.dart';
import 'package:laboratory/settings/logic/settings_cubit.dart';

import 'support/capture_reports.dart';
import 'support/stub_api.dart';

const String _settingsBody =
    '{"data":{"data":['
    '{"key":"lab_available_locales","value":["en","ar"],"is_active":true},'
    '{"key":"lab_default_locale","value":"ar","is_active":true},'
    '{"key":"lab_name","value":{"en":"Central Lab","ar":"المختبر"},'
    '"is_active":true}'
    ']}}';

class _ScriptedRepo extends SettingsRepo {
  _ScriptedRepo(this._results) : super(ApiClient(Dio()));

  final List<Result<LabSettings>> _results;
  int calls = 0;

  @override
  Future<Result<LabSettings>> fetchSettings() async {
    calls++;
    return _results.removeAt(0);
  }
}

class _GatedRepo extends SettingsRepo {
  _GatedRepo() : super(ApiClient(Dio()));

  final Completer<Result<LabSettings>> gate = Completer<Result<LabSettings>>();
  int calls = 0;

  @override
  Future<Result<LabSettings>> fetchSettings() {
    calls++;
    return gate.future;
  }
}

void main() {
  final List<Report> reports = captureReports();

  group('SettingsRepo', () {
    test('reads the settings list', () async {
      final List<RequestOptions> seen = <RequestOptions>[];
      final SettingsRepo repo = SettingsRepo(
        stubApiClient((RequestOptions options) {
          seen.add(options);
          return jsonResponse(_settingsBody);
        }),
      );

      final Result<LabSettings> result = await repo.fetchSettings();

      expect(seen.single.method, 'GET');
      expect(seen.single.path, ApiConstants.settingsList);

      final LabSettings settings = (result as Success<LabSettings>).data;
      expect(settings.isRemote, isTrue);
      expect(settings.defaultLocale, AppLocale.ar);
      expect(settings.nameFor('en', fallback: ''), 'Central Lab');
    });

    test('an empty list is valid: the server has no settings', () async {
      final SettingsRepo repo = SettingsRepo(
        stubApiClient((_) => jsonResponse('{"data":{"data":[]}}')),
      );

      final Result<LabSettings> result = await repo.fetchSettings();

      expect((result as Success<LabSettings>).data.isRemote, isTrue);
    });

    test(
      'a body of the wrong shape fails instead of faking defaults',
      () async {
        final SettingsRepo repo = SettingsRepo(
          stubApiClient((_) => jsonResponse('{"data":"oops"}')),
        );

        final Result<LabSettings> result = await repo.fetchSettings();

        expect(
          (result as Failure<LabSettings>).error.kind,
          AppErrorKind.parsing,
        );
        expect(reports.single.error, isA<FormatException>());
      },
    );

    test('a server error becomes a Failure', () async {
      final SettingsRepo repo = SettingsRepo(
        stubApiClient((_) => jsonResponse('{}', status: 500)),
      );

      final Result<LabSettings> result = await repo.fetchSettings();

      expect((result as Failure<LabSettings>).error.kind, AppErrorKind.server);
      expect(reports, isEmpty);
    });
  });

  group('SettingsCubit', () {
    const LabSettings remote = LabSettings(
      availableLocales: <AppLocale>[AppLocale.en],
      defaultLocale: AppLocale.en,
      names: <String, String>{},
      isRemote: true,
    );
    const AppError offline = AppError(kind: AppErrorKind.network);

    test('starts loading on creation and ends loaded', () async {
      final SettingsCubit cubit = SettingsCubit(
        _ScriptedRepo(<Result<LabSettings>>[
          const Success<LabSettings>(remote),
        ]),
      );
      expect(cubit.state, isA<SettingsLoading>());

      await cubit.stream.first;

      expect(cubit.state, const SettingsLoaded(remote));
      expect(cubit.settings, remote);
      await cubit.close();
    });

    test('a failure keeps the fallback and can be retried', () async {
      final _ScriptedRepo repo = _ScriptedRepo(<Result<LabSettings>>[
        const Failure<LabSettings>(offline),
        const Success<LabSettings>(remote),
      ]);
      final SettingsCubit cubit = SettingsCubit(repo);

      await cubit.stream.first;

      expect((cubit.state as SettingsFailure).error, offline);
      expect(cubit.settings, LabSettings.fallback);

      await cubit.load();

      expect(cubit.state, const SettingsLoaded(remote));
      expect(repo.calls, 2);
      await cubit.close();
    });

    test('ignores load() while a load is in flight', () async {
      final _GatedRepo repo = _GatedRepo();
      final SettingsCubit cubit = SettingsCubit(repo);

      await cubit.load();
      repo.gate.complete(const Success<LabSettings>(remote));
      await cubit.stream.first;

      expect(repo.calls, 1);
      expect(cubit.state, const SettingsLoaded(remote));
      await cubit.close();
    });

    test('a result that arrives after close is dropped', () async {
      final _GatedRepo repo = _GatedRepo();
      final SettingsCubit cubit = SettingsCubit(repo);

      await cubit.close();
      repo.gate.complete(const Success<LabSettings>(remote));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<SettingsLoading>());
    });

    test('does not reload once loaded', () async {
      final _ScriptedRepo repo = _ScriptedRepo(<Result<LabSettings>>[
        const Success<LabSettings>(remote),
      ]);
      final SettingsCubit cubit = SettingsCubit(repo);
      await cubit.stream.firstWhere((SettingsState s) => s is SettingsLoaded);

      await cubit.load();

      expect(repo.calls, 1);
      await cubit.close();
    });
  });
}
