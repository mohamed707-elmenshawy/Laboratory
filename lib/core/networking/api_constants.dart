class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://laboratory-backend.ddev.site/api/v1/';

  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String verify = 'auth/verify';
  static const String forgotPassword = 'auth/forgot-password';
  static const String resetPassword = 'auth/reset-password';
  static const String profile = 'auth/profile';
  static const String logout = 'auth/logout';
  static const String updateProfile = 'auth/update-profile';
  static const String changePassword = 'auth/change-password';
  static const String phoneTypes = 'auth/phone-types';

  static const String laboratories = 'laboratories';
  static const String laboratoriesMenu = 'laboratories/menu';
  static const String branches = 'branches';
  static const String testCategories = 'test-categories';
  static const String sampleTypes = 'sample-types';
  static const String units = 'units';
  static const String users = 'users';
  static const String roles = 'roles';
  static const String parameters = 'parameters';
  static const String settingsList = 'settings/list';
  static const String termsList = 'terms/list';

  static const String authorizationHeader = 'Authorization';
  static const String tenantHeader = 'X-Tenant';
  static const String acceptLanguageHeader = 'Accept-Language';
  static const String listUser = 'users';
}
