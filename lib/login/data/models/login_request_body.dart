class LoginRequestBody {
  const LoginRequestBody({required this.email, required this.password});

  final String email;

  final String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'email': email,
    'password': password,
  };
}
