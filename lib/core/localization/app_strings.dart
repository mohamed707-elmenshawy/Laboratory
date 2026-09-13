import 'app_locale.dart';

abstract class AppStrings {
  const AppStrings();

  factory AppStrings.of(AppLocale locale) => switch (locale) {
    AppLocale.en => const AppStringsEn(),
    AppLocale.ar => const AppStringsAr(),
  };

  String get productName;
  String get productTagline;
  String get brandStatement;
  String get brandStatementSupport;
  List<String> get brandCapabilities;

  String get signInTitle;
  String get signInSubtitle;
  String get emailLabel;
  String get emailHint;
  String get passwordLabel;
  String get passwordHint;
  String get showPassword;
  String get hidePassword;
  String get rememberMe;
  String get rememberMeHint;
  String get forgotPassword;
  String get signIn;
  String get signingIn;
  String get signedIn;
  String get registerPrompt;
  String get registerAction;

  String get emailRequired;
  String get emailInvalid;
  String get emailTooLong;
  String get passwordRequired;

  String get feedbackAuthTitle;
  String get feedbackAccountTitle;
  String get feedbackRateLimitTitle;
  String get feedbackServerTitle;
  String get feedbackNetworkTitle;

  String get networkMessage;
  String rateLimitMessage(int seconds);

  String get feedbackSuccessTitle;
  String signedInAs(String name);

  String get serverErrorMessage;
  String get retry;
  String get verifyEmailAction;
  String get dismiss;

  String get languageSwitcherLabel;
}

class AppStringsEn extends AppStrings {
  const AppStringsEn();

  @override
  String get productName => 'Laboratory';
  @override
  String get productTagline => 'Management System';
  @override
  String get brandStatement =>
      'From sample intake to signed result — on one record.';
  @override
  String get brandStatementSupport =>
      'Multi-branch laboratory operations, inventory and test catalogues, kept consistent across every site.';
  @override
  List<String> get brandCapabilities => const <String>[
    'Laboratories and branches under one tenant',
    'Role-based access, down to a single branch',
    'Inventory, test categories, sample types and units',
  ];

  @override
  String get signInTitle => 'Sign in';
  @override
  String get signInSubtitle =>
      'Enter your credentials to access the laboratory dashboard.';
  @override
  String get emailLabel => 'Email address';
  @override
  String get emailHint => 'name@laboratory.com';
  @override
  String get passwordLabel => 'Password';
  @override
  String get passwordHint => 'Enter your password';
  @override
  String get showPassword => 'Show password';
  @override
  String get hidePassword => 'Hide password';
  @override
  String get rememberMe => 'Remember me';
  @override
  String get rememberMeHint => 'Stay signed in on this computer';
  @override
  String get forgotPassword => 'Forgot password?';
  @override
  String get signIn => 'Sign in';
  @override
  String get signingIn => 'Signing in…';
  @override
  String get signedIn => 'Signed in';
  @override
  String get registerPrompt => 'New laboratory?';
  @override
  String get registerAction => 'Register your laboratory';

  @override
  String get emailRequired => 'Enter your email address.';
  @override
  String get emailInvalid => 'Enter a valid email address.';
  @override
  String get emailTooLong => 'Email address must be 255 characters or fewer.';
  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String get feedbackAuthTitle => 'Sign-in failed';
  @override
  String get feedbackAccountTitle => 'Verify your email to continue';
  @override
  String get feedbackRateLimitTitle => 'Too many attempts';
  @override
  String get feedbackServerTitle => 'Something went wrong';
  @override
  String get feedbackNetworkTitle => 'Can’t reach the server';

  @override
  String get networkMessage => 'Check your connection and try again.';
  @override
  String rateLimitMessage(int seconds) =>
      'For security, sign-in is paused. Try again in ${seconds}s.';
  @override
  String get feedbackSuccessTitle => 'Signed in';
  @override
  String signedInAs(String name) => 'Welcome back, $name.';
  @override
  String get serverErrorMessage =>
      'The server could not complete the request. Please try again.';
  @override
  String get retry => 'Retry';
  @override
  String get verifyEmailAction => 'Verify email';
  @override
  String get dismiss => 'Dismiss';

  @override
  String get languageSwitcherLabel => 'Language';
}

class AppStringsAr extends AppStrings {
  const AppStringsAr();

  @override
  String get productName => 'المختبر';
  @override
  String get productTagline => 'نظام الإدارة';
  @override
  String get brandStatement =>
      'من استلام العينة إلى النتيجة المعتمدة — في سجل واحد.';
  @override
  String get brandStatementSupport =>
      'إدارة المختبرات متعددة الفروع والمخزون وكتالوج التحاليل، بنفس الاتساق في كل موقع.';
  @override
  List<String> get brandCapabilities => const <String>[
    'المختبرات والفروع ضمن مستأجر واحد',
    'صلاحيات حسب الدور، وصولاً إلى فرع واحد',
    'المخزون وفئات التحاليل وأنواع العينات والوحدات',
  ];

  @override
  String get signInTitle => 'تسجيل الدخول';
  @override
  String get signInSubtitle => 'أدخل بياناتك للوصول إلى لوحة تحكم المختبر.';
  @override
  String get emailLabel => 'البريد الإلكتروني';
  @override
  String get emailHint => 'name@laboratory.com';
  @override
  String get passwordLabel => 'كلمة المرور';
  @override
  String get passwordHint => 'أدخل كلمة المرور';
  @override
  String get showPassword => 'إظهار كلمة المرور';
  @override
  String get hidePassword => 'إخفاء كلمة المرور';
  @override
  String get rememberMe => 'تذكرني';
  @override
  String get rememberMeHint => 'إبقائي مسجلاً على هذا الجهاز';
  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';
  @override
  String get signIn => 'تسجيل الدخول';
  @override
  String get signingIn => 'جارٍ تسجيل الدخول…';
  @override
  String get signedIn => 'تم تسجيل الدخول';
  @override
  String get registerPrompt => 'مختبر جديد؟';
  @override
  String get registerAction => 'سجّل مختبرك';

  @override
  String get emailRequired => 'أدخل بريدك الإلكتروني.';
  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صالحًا.';
  @override
  String get emailTooLong => 'يجب ألا يتجاوز البريد الإلكتروني 255 حرفًا.';
  @override
  String get passwordRequired => 'أدخل كلمة المرور.';

  @override
  String get feedbackAuthTitle => 'فشل تسجيل الدخول';
  @override
  String get feedbackAccountTitle => 'تحقق من بريدك الإلكتروني للمتابعة';
  @override
  String get feedbackRateLimitTitle => 'محاولات كثيرة جدًا';
  @override
  String get feedbackServerTitle => 'حدث خطأ ما';
  @override
  String get feedbackNetworkTitle => 'تعذّر الوصول إلى الخادم';

  @override
  String get networkMessage => 'تحقق من اتصالك وحاول مرة أخرى.';
  @override
  String rateLimitMessage(int seconds) =>
      'لأسباب أمنية، تم إيقاف تسجيل الدخول مؤقتًا. حاول مجددًا بعد $seconds ثانية.';
  @override
  String get feedbackSuccessTitle => 'تم تسجيل الدخول';
  @override
  String signedInAs(String name) => 'مرحبًا بعودتك، $name.';
  @override
  String get serverErrorMessage =>
      'تعذّر على الخادم إتمام الطلب. يرجى المحاولة مرة أخرى.';
  @override
  String get retry => 'إعادة المحاولة';
  @override
  String get verifyEmailAction => 'تأكيد البريد الإلكتروني';
  @override
  String get dismiss => 'إغلاق';

  @override
  String get languageSwitcherLabel => 'اللغة';
}
