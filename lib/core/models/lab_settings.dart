import 'package:equatable/equatable.dart';

import '../localization/app_locale.dart';

class LabSettings extends Equatable {
  const LabSettings({
    required this.availableLocales,
    required this.defaultLocale,
    required this.names,
    this.logoUrl,
    this.isRemote = false,
  });

  static const LabSettings fallback = LabSettings(
    availableLocales: AppLocale.values,
    defaultLocale: AppLocale.en,
    names: <String, String>{},
  );

  final List<AppLocale> availableLocales;
  final AppLocale defaultLocale;
  final Map<String, String> names;
  final String? logoUrl;
  final bool isRemote;

  String nameFor(String localeCode, {required String fallback}) {
    if (names.isEmpty) return fallback;

    final String language = _languageOf(localeCode).toLowerCase();
    return names[localeCode] ??
        names[language] ??
        names[AppLocale.en.code] ??
        names.values.first;
  }

  factory LabSettings.fromJson(dynamic json) {
    return LabSettings.fromItems(_itemsOf(json), isRemote: true);
  }

  factory LabSettings.fromItems(List<dynamic> items, {bool isRemote = false}) {
    List<AppLocale> locales = List<AppLocale>.from(AppLocale.values);
    AppLocale defaultLocale = AppLocale.en;
    Map<String, String> names = const <String, String>{};
    String? logoUrl;

    for (final dynamic item in items) {
      if (item is! Map) continue;

      final Map<String, dynamic> map = Map<String, dynamic>.from(item);
      if (map['is_active'] == false) continue;

      final String key = map['key'] as String? ?? '';
      final Object? value = map['value'];

      switch (key) {
        case 'lab_available_locales':
          final List<AppLocale> parsed = _stringList(value)
              .map(AppLocale.tryParse)
              .whereType<AppLocale>()
              .toList(growable: false);
          if (parsed.isNotEmpty) locales = parsed;
        case 'lab_default_locale':
          defaultLocale = AppLocale.tryParse(_asString(value)) ?? defaultLocale;
        case 'lab_name':
          names = _localizedMap(value);
        case 'lab_logo':
          final String? url = _asString(value);
          if (url != null && url.isNotEmpty) logoUrl = url;
      }
    }

    if (!locales.contains(defaultLocale)) {
      defaultLocale = locales.first;
    }

    return LabSettings(
      availableLocales: locales,
      defaultLocale: defaultLocale,
      names: names,
      logoUrl: logoUrl,
      isRemote: isRemote,
    );
  }

  static List<dynamic> _itemsOf(dynamic json) {
    if (json is List) return json;
    if (json is! Map) return const <dynamic>[];

    final Object? data = json['data'];
    if (data is List) return data;
    if (data is Map) {
      final Object? inner = data['data'];
      if (inner is List) return inner;
    }

    return const <dynamic>[];
  }

  static List<String> _stringList(Object? value) {
    if (value is List) {
      return value
          .map(_asString)
          .whereType<String>()
          .where((String item) => item.isNotEmpty)
          .toList(growable: false);
    }

    final String? single = _asString(value);
    if (single == null || single.isEmpty) return const <String>[];
    return <String>[single];
  }

  static Map<String, String> _localizedMap(Object? value) {
    if (value is String && value.isNotEmpty) {
      return <String, String>{AppLocale.en.code: value};
    }

    if (value is Map) {
      final Map<String, String> result = <String, String>{};
      value.forEach((Object? key, Object? item) {
        if (key is! String || key.isEmpty) return;
        final String? text = _asString(item);
        if (text == null || text.isEmpty) return;
        result[key.trim().toLowerCase()] = text;
      });
      return result;
    }

    return const <String, String>{};
  }

  static String? _asString(Object? value) => switch (value) {
    final String text => text,
    null => null,
    _ => value.toString(),
  };

  static String _languageOf(String localeCode) {
    final int separator = localeCode.indexOf(RegExp('[-_]'));
    return separator == -1 ? localeCode : localeCode.substring(0, separator);
  }

  @override
  List<Object?> get props => <Object?>[
    availableLocales,
    defaultLocale,
    names,
    logoUrl,
    isRemote,
  ];
}
