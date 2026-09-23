import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/core/ui/ui.dart';

void main() {
  const LabSettings settings = LabSettings(
    availableLocales: <AppLocale>[AppLocale.en, AppLocale.ar],
    defaultLocale: AppLocale.en,
    names: <String, String>{
      'en': 'Central Laboratory',
      'ar': 'المختبر المركزي',
    },
    isRemote: true,
  );

  Widget app({required AppLocale locale}) {
    return AppLocaleScope(
      initialLocale: locale,
      settings: settings,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) => Column(
              children: <Widget>[
                AppLanguageSwitcher(
                  value: context.appLocale,
                  onChanged: context.setAppLocale,
                  semanticLabel: context.strings.languageSwitcherLabel,
                ),
                AppLogoLockup(
                  productName: context.strings.productName,
                  tagline: context.strings.productTagline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('language menu lists backend locales', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(app(locale: AppLocale.en));

    await tester.tap(find.byType(DropdownButton<AppLocale>));
    await tester.pumpAndSettle();

    expect(find.text('English').evaluate().length, greaterThanOrEqualTo(1));
    expect(find.text('العربية'), findsOneWidget);
  });

  testWidgets('logo lockup uses localized lab name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(app(locale: AppLocale.en));
    expect(find.text('Central Laboratory'), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<AppLocale>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();

    expect(find.text('المختبر المركزي'), findsOneWidget);
  });
}
