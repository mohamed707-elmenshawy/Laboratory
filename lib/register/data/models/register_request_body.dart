class RegisterRequestBody {
  const RegisterRequestBody({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.termAndCondition,
  });

  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final bool termAndCondition;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'email': email,
    'password': password,
    'password_confirmation': passwordConfirmation,
    'term_and_condition': termAndCondition,
  };
}
