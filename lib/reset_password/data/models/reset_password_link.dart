class ResetPasswordLink {
  const ResetPasswordLink({required this.email, required this.token});

  static const String path = '/reset-password';

  final String email;
  final String token;

  static ResetPasswordLink? fromUri(Uri uri) {
    if (!uri.path.endsWith(path)) return null;

    final String email = (uri.queryParameters['email'] ?? '').trim();
    final String token = (uri.queryParameters['token'] ?? '').trim();

    if (email.isEmpty || token.isEmpty) return null;
    return ResetPasswordLink(email: email, token: token);
  }
}
