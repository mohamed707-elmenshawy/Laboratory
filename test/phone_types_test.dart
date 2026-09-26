import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/profile/UI/widgets/profile_phones_card.dart';
import 'package:laboratory/profile/UI/widgets/profile_save_button.dart';
import 'package:laboratory/profile/data/models/phone_type_option.dart';
import 'package:laboratory/profile/data/models/profile_model.dart';
import 'package:laboratory/profile/data/models/update_profile_request_body.dart';
import 'package:laboratory/profile/data/repos/profile_repo.dart';
import 'package:laboratory/profile/logic/profile_cubit.dart';
import 'package:laboratory/profile/logic/update_profile_cubit.dart';

const List<PhoneTypeOption> _english = <PhoneTypeOption>[
  PhoneTypeOption(value: 'both', label: 'Both'),
  PhoneTypeOption(value: 'phone', label: 'Phone'),
  PhoneTypeOption(value: 'whatsapp', label: 'WhatsApp'),
];

const List<PhoneTypeOption> _arabic = <PhoneTypeOption>[
  PhoneTypeOption(value: 'both', label: 'الهاتف والواتساب'),
  PhoneTypeOption(value: 'phone', label: 'هاتف'),
  PhoneTypeOption(value: 'whatsapp', label: 'واتساب'),
];

ProfileModel _profile({List<ProfilePhone> phones = const <ProfilePhone>[]}) =>
    ProfileModel(
      id: 1,
      name: 'Abdo',
      email: 'admin@email.com',
      tenantId: null,
      branchId: null,
      phones: phones,
    );

class FakeProfileRepo implements ProfileRepo {
  FakeProfileRepo({this.typesError = false});

  final bool typesError;

  int typeCalls = 0;
  List<PhoneTypeOption> types = _english;
  final List<Map<String, dynamic>> sent = <Map<String, dynamic>>[];

  @override
  Future<Result<ProfileModel>> fetchProfile() async => Success<ProfileModel>(
    _profile(
      phones: <ProfilePhone>[
        const ProfilePhone(
          id: 6,
          phone: '01095538077',
          phoneCountry: 'EG',
          type: 'phone',
          typeLabel: 'Phone',
          dialCode: '+20',
        ),
      ],
    ),
  );

  @override
  Future<Result<List<PhoneTypeOption>>> fetchPhoneTypes() async {
    typeCalls++;

    if (typesError) {
      return const Failure<List<PhoneTypeOption>>(
        AppError(kind: AppErrorKind.network),
      );
    }
    return Success<List<PhoneTypeOption>>(types);
  }

  @override
  Future<Result<ProfileModel>> updateProfile(
    UpdateProfileRequestBody body,
  ) async {
    sent.add(body.toJson());
    return Success<ProfileModel>(_profile());
  }
}

Widget _editor(UpdateProfileCubit cubit, List<PhoneTypeOption> types) =>
    AppLocaleScope(
      child: MaterialApp(
        home: Scaffold(
          body: BlocProvider<UpdateProfileCubit>.value(
            value: cubit,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteractionIfError,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ProfilePhonesCard(phoneTypes: types),
                    const ProfileSaveButton(),
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

void main() {
  test('loading the profile also loads the phone types', () async {
    final FakeProfileRepo repo = FakeProfileRepo();
    final ProfileCubit cubit = ProfileCubit(repo);

    await cubit.loadProfile();

    expect(repo.typeCalls, 1);
    expect((cubit.state as ProfileLoaded).phoneTypes, _english);

    await cubit.close();
  });

  test('a failed phone-types call leaves the list empty', () async {
    final ProfileCubit cubit = ProfileCubit(FakeProfileRepo(typesError: true));

    await cubit.loadProfile();

    expect(cubit.state, isA<ProfileLoaded>());
    expect((cubit.state as ProfileLoaded).phoneTypes, isEmpty);

    await cubit.close();
  });

  test('switching language refetches the labels', () async {
    final FakeProfileRepo repo = FakeProfileRepo();
    final ProfileCubit cubit = ProfileCubit(repo);

    await cubit.loadProfile();
    expect((cubit.state as ProfileLoaded).phoneTypes, _english);

    repo.types = _arabic;
    await cubit.localeChanged();

    expect(repo.typeCalls, 2);
    expect((cubit.state as ProfileLoaded).phoneTypes, _arabic);

    await cubit.close();
  });

  testWidgets('the type select shows the labels the endpoint returned', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeProfileRepo repo = FakeProfileRepo();
    final UpdateProfileCubit cubit = UpdateProfileCubit(repo)
      ..seed(
        _profile(
          phones: <ProfilePhone>[
            const ProfilePhone(
              id: 6,
              phone: '01095538077',
              phoneCountry: 'EG',
              type: 'phone',
            ),
          ],
        ),
      );
    addTearDown(cubit.close);

    await tester.pumpWidget(_editor(cubit, _arabic));
    await tester.pumpAndSettle();

    expect(find.text('هاتف'), findsOneWidget);

    await tester.tap(find.text('هاتف'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('الهاتف والواتساب').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final List<dynamic> phones = repo.sent.single['phones'] as List<dynamic>;
    expect(phones.single, containsPair('type', 'both'));
  });

  testWidgets('without the endpoint the local labels are used', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final UpdateProfileCubit cubit = UpdateProfileCubit(FakeProfileRepo())
      ..seed(
        _profile(
          phones: <ProfilePhone>[
            const ProfilePhone(
              id: 6,
              phone: '01095538077',
              phoneCountry: 'EG',
              type: 'whatsapp',
            ),
          ],
        ),
      );
    addTearDown(cubit.close);

    await tester.pumpWidget(_editor(cubit, const <PhoneTypeOption>[]));
    await tester.pumpAndSettle();

    expect(find.text('WhatsApp'), findsOneWidget);
  });

  testWidgets('an unknown type falls back to the first option', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final UpdateProfileCubit cubit = UpdateProfileCubit(FakeProfileRepo())
      ..seed(
        _profile(
          phones: <ProfilePhone>[
            const ProfilePhone(
              id: 6,
              phone: '01095538077',
              phoneCountry: 'EG',
              type: 'sms',
            ),
          ],
        ),
      );
    addTearDown(cubit.close);

    await tester.pumpWidget(_editor(cubit, _english));
    await tester.pumpAndSettle();

    expect(find.text('Both'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
