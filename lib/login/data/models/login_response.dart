import '../../../core/models/user_model.dart';

class LoginResponse {
  final UserModel user;
  final String token;
  final String tokenType;

  const LoginResponse({
    required this.user,
    required this.token,
    required this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    user: UserModel.fromJson(
      Map<String, dynamic>.from(json['user'] as Map<dynamic, dynamic>),
    ),
    token: json['token'] as String? ?? '',
    tokenType: json['token_type'] as String? ?? 'Bearer',
  );
}
