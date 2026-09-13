import 'package:flutter/widgets.dart';

import 'app_locale.dart';
import 'app_strings.dart';

class AppLocaleScope extends StatefulWidget {
  const AppLocaleScope({
    super.key,
    required this.child,
    this.initialLocale = AppLocale.en,
    this.onLocaleChanged,
  });

  final Widget child;
  final AppLocale initialLocale;

  final ValueChanged<AppLocale>? onLocaleChanged;

  @override
  State<AppLocaleScope> createState() => _AppLocaleScopeState();
}

class _AppLocaleScopeState extends State<AppLocaleScope> {
  late AppLocale _locale = widget.initialLocale;

  void _setLocale(AppLocale locale) {
    if (locale == _locale) return;
    setState(() => _locale = locale);
    widget.onLocaleChanged?.call(locale);
  }

  @override
  Widget build(BuildContext context) {
    return _AppLocaleProvider(
      locale: _locale,
      strings: AppStrings.of(_locale),
      setLocale: _setLocale,
      child: widget.child,
    );
  }
}

class _AppLocaleProvider extends InheritedWidget {
  const _AppLocaleProvider({
    required this.locale,
    required this.strings,
    required this.setLocale,
    required super.child,
  });

  final AppLocale locale;
  final AppStrings strings;
  final ValueChanged<AppLocale> setLocale;

  @override
  bool updateShouldNotify(_AppLocaleProvider oldWidget) =>
      oldWidget.locale != locale;
}

extension AppLocalizationX on BuildContext {
  _AppLocaleProvider get _provider {
    final _AppLocaleProvider? provider =
        dependOnInheritedWidgetOfExactType<_AppLocaleProvider>();
    assert(provider != null, 'No AppLocaleScope found above this widget.');
    return provider!;
  }

  AppStrings get strings => _provider.strings;

  AppLocale get appLocale => _provider.locale;

  void setAppLocale(AppLocale locale) => _provider.setLocale(locale);
}
