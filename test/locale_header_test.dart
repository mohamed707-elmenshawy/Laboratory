import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/localization/app_locale.dart';
import 'package:laboratory/core/networking/dio_factory.dart';

void main() {
  test('selected language is sent as uppercase Accept-Language', () {
    DioFactory.setLocale(AppLocale.ar.code);
    expect(DioFactory.localeCode, 'AR');

    DioFactory.setLocale(AppLocale.en.code);
    expect(DioFactory.localeCode, 'EN');
  });
}
