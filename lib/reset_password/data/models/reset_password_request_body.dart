class ResetPasswordRequestBody {
  const ResetPasswordRequestBody({
    required this.token,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  final String token;
  final String email;
  final String password;
  final String passwordConfirmation;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'token': token,
    'email': email,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };
}
