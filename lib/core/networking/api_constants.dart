class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://laboratory-backend.ddev.site/api/';

  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String verify = 'auth/verify';
  static const String forgotPassword = 'auth/forgot-password';
  static const String resetPassword = 'auth/reset-password';
  static const String profile = 'auth/profile';
  static const String logout = 'auth/logout';

  static const String authorizationHeader = 'Authorization';
  static const String tenantHeader = 'X-Tenant';
  static const String acceptLanguageHeader = 'Accept-Language';
}
