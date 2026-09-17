import '../../../core/models/user_model.dart';

class RegisterResponse {
  const RegisterResponse({required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(user: UserModel.fromJson(json));

  final UserModel user;
}
