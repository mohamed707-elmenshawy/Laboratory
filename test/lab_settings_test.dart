import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/localization/app_locale.dart';
import 'package:laboratory/core/models/lab_settings.dart';

void main() {
  test('parses lab locales, localized name, and logo from settings/list', () {
    const Map<String, dynamic> response = <String, dynamic>{
      'data': <String, dynamic>{
        'data': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 7,
            'key': 'lab_available_locales',
            'value': <String>['en', 'ar'],
            'is_active': true,
          },
          <String, dynamic>{
            'id': 8,
            'key': 'lab_default_locale',
            'value': 'en',
            'is_active': true,
          },
          <String, dynamic>{
            'id': 1,
            'key': 'lab_logo',
            'value':
                'https://laboratory-backend.ddev.site/storage/media/logo.svg',
            'is_active': true,
          },
          <String, dynamic>{
            'id': 2,
            'key': 'lab_name',
            'value': <String, String>{
              'ar': 'المختبر المركزي',
              'en': 'Central Laboratory',
            },
            'is_active': true,
          },
        ],
      },
    };

    final LabSettings settings = LabSettings.fromJson(response);

    expect(settings.isRemote, isTrue);
    expect(settings.availableLocales, <AppLocale>[AppLocale.en, AppLocale.ar]);
    expect(settings.defaultLocale, AppLocale.en);
    expect(settings.logoUrl, endsWith('logo.svg'));
    expect(
      settings.nameFor('en', fallback: 'Laboratory'),
      'Central Laboratory',
    );
    expect(settings.nameFor('ar', fallback: 'المختبر'), 'المختبر المركزي');
  });
}
