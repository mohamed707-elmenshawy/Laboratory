class LoginResponse {
  final String token;
  final String tokenType;
  final List<String> roles;
  final List<String> permissions;

  const LoginResponse({
    required this.token,
    required this.tokenType,
    required this.roles,
    required this.permissions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json['token'] as String? ?? '',
    tokenType: json['token_type'] as String? ?? 'Bearer',
    roles: _stringList(json['roles']),
    permissions: _stringList(json['permissions']),
  );
}

List<String> _stringList(Object? value) {
  if (value is! List) return const <String>[];

  return value
      .map((dynamic item) => item.toString())
      .toList(growable: false);
}
