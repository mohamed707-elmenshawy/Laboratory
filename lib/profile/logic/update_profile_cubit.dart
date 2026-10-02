import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/profile_model.dart';
import '../data/models/update_profile_request_body.dart';
import '../data/repos/profile_repo.dart';
import '../../core/phones/phones.dart';
part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit(this._profileRepo) : super(const UpdateProfileInitial());

  static const int maxPhones = 5;

  final ProfileRepo _profileRepo;

  final TextEditingController nameController = TextEditingController();

  final ValueNotifier<List<PhoneDraft>> phones =
      ValueNotifier<List<PhoneDraft>>(<PhoneDraft>[]);

  final List<PhoneDraft> _retired = <PhoneDraft>[];

  bool get isBusy => state is UpdateProfileLoading;

  bool get canAddPhone => phones.value.length < maxPhones;

  void seed(ProfileModel profile) {
    nameController.text = profile.name;
    _replacePhones(
      profile.phones
          .map(
            (ProfilePhone phone) => PhoneDraft(
              id: phone.id == 0 ? null : phone.id,
              phone: phone.phone,
              country: phone.phoneCountry,
              type: phone.type,
              dialCode: phone.dialCode,
            ),
          )
          .toList(growable: false),
    );
  }

  void addPhone() {
    if (!canAddPhone) return;
    _clearFailure();
    phones.value = <PhoneDraft>[...phones.value, PhoneDraft()];
  }

  void removePhone(PhoneDraft phone) {
    if (!phones.value.contains(phone)) return;

    _clearFailure();
    phones.value = phones.value
        .where((PhoneDraft draft) => draft != phone)
        .toList(growable: false);
    _retired.add(phone);
  }

  void setCountry(PhoneDraft phone, String country) {
    if (phone.country == country) return;
    _clearFailure();
    phone.country = country;
    phones.value = List<PhoneDraft>.of(phones.value);
  }

  void setType(PhoneDraft phone, String type) {
    if (phone.type == type) return;
    _clearFailure();
    phone.type = type;
    phones.value = List<PhoneDraft>.of(phones.value);
  }

  void phoneEdited() => _clearFailure();

  String? duplicateOf(PhoneDraft phone) {
    final String value = phone.phone;
    if (value.isEmpty) return null;

    for (final PhoneDraft other in phones.value) {
      if (identical(other, phone)) break;
      if (other.phone == value) return value;
    }
    return null;
  }

  Future<void> save() async {
    if (isBusy) return;

    emit(const UpdateProfileLoading());

    final Result<ProfileModel> result = await _profileRepo.updateProfile(
      UpdateProfileRequestBody(
        name: nameController.text.trim(),
        phones: phones.value
            .where((PhoneDraft phone) => !phone.isEmpty)
            .map((PhoneDraft phone) => phone.toPayload())
            .toList(growable: false),
      ),
    );

    if (isClosed) return;

    switch (result) {
      case Success<ProfileModel>(:final ProfileModel data):
        seed(data);
        emit(UpdateProfileSuccess(data));
      case Failure<ProfileModel>(:final AppError error):
        emit(UpdateProfileFailure(error));
    }
  }

  void dismissFeedback() {
    if (state is UpdateProfileSuccess || state is UpdateProfileFailure) {
      emit(const UpdateProfileInitial());
    }
  }

  void _clearFailure() {
    if (state is UpdateProfileFailure) emit(const UpdateProfileInitial());
  }

  void _replacePhones(List<PhoneDraft> drafts) {
    _retired.addAll(phones.value);
    phones.value = drafts;
  }

  @override
  Future<void> close() {
    nameController.dispose();
    for (final PhoneDraft draft in <PhoneDraft>[...phones.value, ..._retired]) {
      draft.dispose();
    }
    phones.dispose();
    return super.close();
  }
}
