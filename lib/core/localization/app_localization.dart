import 'package:flutter/widgets.dart';

import '../models/lab_settings.dart';
import 'app_locale.dart';
import 'app_strings.dart';

class AppLocaleScope extends StatefulWidget {
  const AppLocaleScope({
    super.key,
    required this.child,
    this.initialLocale = AppLocale.en,
    this.settings = LabSettings.fallback,
    this.hasSavedLocale = false,
    this.onLocaleChanged,
  });

  final Widget child;
  final AppLocale initialLocale;
  final LabSettings settings;
  final bool hasSavedLocale;

  final ValueChanged<AppLocale>? onLocaleChanged;

  @override
  State<AppLocaleScope> createState() => _AppLocaleScopeState();
}

class _AppLocaleScopeState extends State<AppLocaleScope> {
  late AppLocale _locale = widget.initialLocale;
  bool _userChanged = false;

  @override
  void didUpdateWidget(AppLocaleScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings == widget.settings) return;

    final LabSettings settings = widget.settings;
    if (!settings.isRemote) return;

    if (!widget.hasSavedLocale &&
        !_userChanged &&
        !oldWidget.settings.isRemote) {
      _setLocale(settings.defaultLocale);
      return;
    }

    if (!settings.availableLocales.contains(_locale)) {
      _setLocale(settings.defaultLocale);
    }
  }

  void _setLocale(AppLocale locale, {bool fromUser = false}) {
    if (fromUser) _userChanged = true;
    if (locale == _locale) return;
    setState(() => _locale = locale);
    widget.onLocaleChanged?.call(locale);
  }

  @override
  Widget build(BuildContext context) {
    return _AppLocaleProvider(
      locale: _locale,
      strings: AppStrings.of(_locale),
      settings: widget.settings,
      setLocale: (AppLocale locale) => _setLocale(locale, fromUser: true),
      child: widget.child,
    );
  }
}

class _AppLocaleProvider extends InheritedWidget {
  const _AppLocaleProvider({
    required this.locale,
    required this.strings,
    required this.settings,
    required this.setLocale,
    required super.child,
  });

  final AppLocale locale;
  final AppStrings strings;
  final LabSettings settings;
  final ValueChanged<AppLocale> setLocale;

  @override
  bool updateShouldNotify(_AppLocaleProvider oldWidget) =>
      oldWidget.locale != locale || oldWidget.settings != settings;
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

  LabSettings get labSettings => _provider.settings;

  void setAppLocale(AppLocale locale) => _provider.setLocale(locale);
}
