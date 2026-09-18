class ChangePasswordRequestBody {
  const ChangePasswordRequestBody({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'current_password': currentPassword,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };
}
