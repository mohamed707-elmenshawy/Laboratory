import '../../../core/models/user_model.dart';

class VerificationResponse {
  const VerificationResponse({required this.user});

  factory VerificationResponse.fromJson(Map<String, dynamic> json) =>
      VerificationResponse(user: UserModel.fromJson(json));

  final UserModel user;
}
