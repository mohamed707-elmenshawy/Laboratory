import 'package:shared_preferences/shared_preferences.dart';

import '../localization/app_locale.dart';

class LocaleHelper {
  LocaleHelper._();

  static const String _key = 'appLocale';

  static Future<AppLocale?> restore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return AppLocale.tryParse(prefs.getString(_key));
  }

  static Future<void> persist(AppLocale locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.code);
  }
}
