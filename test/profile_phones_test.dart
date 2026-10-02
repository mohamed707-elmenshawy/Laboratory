import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/profile/UI/widgets/profile_phones_card.dart';
import 'package:laboratory/profile/UI/widgets/profile_save_button.dart';
import 'package:laboratory/core/phones/phones.dart';
import 'package:laboratory/profile/data/models/profile_model.dart';
import 'package:laboratory/profile/data/models/update_profile_request_body.dart';
import 'package:laboratory/profile/data/repos/profile_repo.dart';
import 'package:laboratory/profile/logic/update_profile_cubit.dart';

const List<PhoneTypeOption> _types = <PhoneTypeOption>[
  PhoneTypeOption(value: 'both', label: 'Both'),
  PhoneTypeOption(value: 'phone', label: 'Phone'),
  PhoneTypeOption(value: 'whatsapp', label: 'WhatsApp'),
];

ProfileModel _profile({List<ProfilePhone> phones = const <ProfilePhone>[]}) =>
    ProfileModel(
      id: 7,
      name: 'Probe User',
      email: 'probe@example.com',
      tenantId: null,
      branchId: null,
      phones: phones,
    );

class FakeProfileRepo implements ProfileRepo {
  FakeProfileRepo({this.error});

  final AppError? error;

  final List<Map<String, dynamic>> sent = <Map<String, dynamic>>[];

  @override
  Future<Result<ProfileModel>> fetchProfile() async =>
      Success<ProfileModel>(_profile());

  @override
  Future<Result<List<PhoneTypeOption>>> fetchPhoneTypes() async =>
      const Success<List<PhoneTypeOption>>(_types);

  @override
  Future<Result<ProfileModel>> updateProfile(
    UpdateProfileRequestBody body,
  ) async {
    sent.add(body.toJson());

    if (error != null) return Failure<ProfileModel>(error!);

    final List<dynamic> phones =
        (body.toJson()['phones'] as List<dynamic>?) ?? <dynamic>[];

    return Success<ProfileModel>(
      _profile(
        phones: <ProfilePhone>[
          for (int i = 0; i < phones.length; i++)
            ProfilePhone(
              id: (phones[i] as Map<String, dynamic>)['id'] as int? ?? 90 + i,
              phone: (phones[i] as Map<String, dynamic>)['phone'] as String,
              phoneCountry:
                  (phones[i] as Map<String, dynamic>)['phone_country']
                      as String,
              type: (phones[i] as Map<String, dynamic>)['type'] as String,
            ),
        ],
      ),
    );
  }
}

Widget _editor(UpdateProfileCubit cubit) => AppLocaleScope(
  child: MaterialApp(
    home: Scaffold(
      body: BlocProvider<UpdateProfileCubit>.value(
        value: cubit,
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          child: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                ProfilePhonesCard(phoneTypes: _types),
                ProfileSaveButton(),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);

void _desktop(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

UpdateProfileCubit _cubit(
  FakeProfileRepo repo, {
  List<ProfilePhone> phones = const <ProfilePhone>[],
}) {
  final UpdateProfileCubit cubit = UpdateProfileCubit(repo)
    ..seed(_profile(phones: phones));
  addTearDown(cubit.close);
  return cubit;
}

void main() {
  for (final double width in <double>[640, 420]) {
    testWidgets('the editor lays out without overflow at ${width}px', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = Size(width, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final UpdateProfileCubit cubit = _cubit(
        FakeProfileRepo(),
        phones: <ProfilePhone>[
          const ProfilePhone(
            id: 6,
            phone: '01095538077',
            phoneCountry: 'EG',
            type: 'phone',
          ),
          const ProfilePhone(
            id: 9,
            phone: '01007907751',
            phoneCountry: 'SA',
            type: 'both',
          ),
        ],
      );

      await tester.pumpWidget(_editor(cubit));
      await tester.pumpAndSettle();

      expect(find.text('01095538077'), findsOneWidget);
      expect(find.text('+966'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Add number'));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Cancel this number'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('existing numbers are shown and can be edited', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeProfileRepo repo = FakeProfileRepo();
    final UpdateProfileCubit cubit = _cubit(
      repo,
      phones: <ProfilePhone>[
        const ProfilePhone(
          id: 6,
          phone: '01095538077',
          phoneCountry: 'EG',
          type: 'phone',
        ),
      ],
    );

    await tester.pumpWidget(_editor(cubit));
    await tester.pumpAndSettle();

    expect(find.text('01095538077'), findsOneWidget);
    expect(find.text('+20'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('1 of 5'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '01095538099');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(repo.sent.single, <String, dynamic>{
      'name': 'Probe User',
      'phones': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 6,
          'phone': '01095538099',
          'phone_country': 'EG',
          'type': 'phone',
        },
      ],
    });
  });

  testWidgets('a number added through the button is sent without an id', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeProfileRepo repo = FakeProfileRepo();
    final UpdateProfileCubit cubit = _cubit(
      repo,
      phones: <ProfilePhone>[
        const ProfilePhone(
          id: 6,
          phone: '01095538077',
          phoneCountry: 'EG',
          type: 'phone',
        ),
      ],
    );

    await tester.pumpWidget(_editor(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add number'));
    await tester.pumpAndSettle();

    expect(find.text('2 of 5'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, '01007907751');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final List<dynamic> phones = repo.sent.single['phones'] as List<dynamic>;
    expect(phones.length, 2);
    expect(phones.first, containsPair('id', 6));
    expect(phones.last.containsKey('id'), isFalse);
    expect(phones.last, containsPair('phone', '01007907751'));
    expect(phones.last, containsPair('type', 'phone'));
  });

  testWidgets('saved numbers have no cancel button', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final UpdateProfileCubit cubit = _cubit(
      FakeProfileRepo(),
      phones: <ProfilePhone>[
        const ProfilePhone(
          id: 6,
          phone: '01095538077',
          phoneCountry: 'EG',
          type: 'phone',
        ),
        const ProfilePhone(
          id: 9,
          phone: '01095538076',
          phoneCountry: 'EG',
          type: 'both',
        ),
      ],
    );

    await tester.pumpWidget(_editor(cubit));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Cancel this number'), findsNothing);

    await tester.tap(find.text('Add number'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Cancel this number'), findsOneWidget);
  });

  testWidgets('cancelling a just-added number drops it again', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeProfileRepo repo = FakeProfileRepo();
    final UpdateProfileCubit cubit = _cubit(
      repo,
      phones: <ProfilePhone>[
        const ProfilePhone(
          id: 6,
          phone: '01095538077',
          phoneCountry: 'EG',
          type: 'phone',
        ),
      ],
    );

    await tester.pumpWidget(_editor(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add number'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '01007907751');
    expect(find.text('2 of 5'), findsOneWidget);

    await tester.tap(find.byTooltip('Cancel this number'));
    await tester.pumpAndSettle();

    expect(find.text('01007907751'), findsNothing);
    expect(find.text('1 of 5'), findsOneWidget);

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final List<dynamic> phones = repo.sent.single['phones'] as List<dynamic>;
    expect(phones.single, containsPair('id', 6));
  });

  testWidgets('an account with no numbers sends phones as null', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeProfileRepo repo = FakeProfileRepo();
    final UpdateProfileCubit cubit = _cubit(repo);

    await tester.pumpWidget(_editor(cubit));
    await tester.pumpAndSettle();

    expect(find.text('No phone numbers on your account.'), findsOneWidget);

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(repo.sent.single, <String, dynamic>{
      'name': 'Probe User',
      'phones': null,
    });
  });

  testWidgets('an empty or duplicated number blocks the save', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeProfileRepo repo = FakeProfileRepo();
    final UpdateProfileCubit cubit = _cubit(repo);

    await tester.pumpWidget(_editor(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add number'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a phone number.'), findsOneWidget);
    expect(repo.sent, isEmpty);

    await tester.enterText(find.byType(TextField).first, '01095538077');
    await tester.tap(find.text('Add number'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '01095538077');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('This number is already in the list.'), findsOneWidget);
    expect(repo.sent, isEmpty);
  });

  testWidgets('the add button stops at five numbers', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final UpdateProfileCubit cubit = _cubit(FakeProfileRepo());

    await tester.pumpWidget(_editor(cubit));
    await tester.pumpAndSettle();

    for (int i = 0; i < 6; i++) {
      cubit.addPhone();
      await tester.pumpAndSettle();
    }

    expect(cubit.phones.value.length, 5);
    expect(find.text('5 of 5'), findsOneWidget);
    expect(find.text('You can save up to 5 numbers.'), findsOneWidget);
  });

  testWidgets('spaces and dashes are stripped before sending', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeProfileRepo repo = FakeProfileRepo();
    final UpdateProfileCubit cubit = _cubit(repo);

    await tester.pumpWidget(_editor(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add number'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '010 9553-8077');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final List<dynamic> phones = repo.sent.single['phones'] as List<dynamic>;
    expect(phones.single, containsPair('phone', '01095538077'));
  });

  testWidgets('editing a number clears a previous server error', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeProfileRepo repo = FakeProfileRepo(
      error: const AppError(
        kind: AppErrorKind.validation,
        statusCode: 422,
        fieldErrors: <String, List<String>>{
          'phones.0.phone': <String>['The phone has already been taken.'],
        },
      ),
    );
    final UpdateProfileCubit cubit = _cubit(
      repo,
      phones: <ProfilePhone>[
        const ProfilePhone(
          id: 6,
          phone: '01095538077',
          phoneCountry: 'EG',
          type: 'phone',
        ),
      ],
    );

    await tester.pumpWidget(_editor(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('The phone has already been taken.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '01095538078');
    await tester.pumpAndSettle();

    expect(find.text('The phone has already been taken.'), findsNothing);

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(repo.sent.length, 2);
  });

  testWidgets('a server error for one number is shown on that row', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeProfileRepo repo = FakeProfileRepo(
      error: const AppError(
        kind: AppErrorKind.validation,
        statusCode: 422,
        message: 'Validation Error',
        fieldErrors: <String, List<String>>{
          'phones.1.phone': <String>['The phone field must be a valid number.'],
        },
      ),
    );
    final UpdateProfileCubit cubit = _cubit(
      repo,
      phones: <ProfilePhone>[
        const ProfilePhone(
          id: 6,
          phone: '01095538077',
          phoneCountry: 'EG',
          type: 'phone',
        ),
        const ProfilePhone(
          id: 9,
          phone: '01095538076',
          phoneCountry: 'EG',
          type: 'both',
        ),
      ],
    );

    await tester.pumpWidget(_editor(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(
      find.text('The phone field must be a valid number.'),
      findsOneWidget,
    );
  });
}
