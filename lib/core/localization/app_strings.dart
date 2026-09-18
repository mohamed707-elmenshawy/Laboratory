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

  String get registerTitle;
  String get registerSubtitle;
  String get nameLabel;
  String get nameHint;
  String get nameRequired;
  String get nameTooLong;
  String get newPasswordHint;
  String get passwordTooShort;
  String get passwordConfirmationLabel;
  String get passwordConfirmationHint;
  String get passwordConfirmationRequired;
  String get passwordMismatch;
  String get termsLabel;
  String get termsHint;
  String get termsRequired;
  String get createAccount;
  String get creatingAccount;
  String get accountCreated;
  String get feedbackRegisterTitle;
  String get registerSuccessTitle;
  String registerSuccessMessage(String email);
  String get signInPrompt;
  String get signInAction;

  String get verificationTitle;
  String verificationSubtitle(String email);
  String get codeLabel;
  String get codeHint;
  String get codeRequired;
  String get codeLength;
  String get verifying;
  String get verified;
  String get feedbackVerificationTitle;
  String get verificationSuccessTitle;
  String get verificationSuccessMessage;
  String get verifiedPrompt;

  String get forgotPasswordTitle;
  String get forgotPasswordSubtitle;
  String get sendResetLink;
  String get sendingResetLink;
  String get resetLinkSent;
  String get feedbackForgotPasswordTitle;
  String get resetLinkSentTitle;
  String resetLinkSentMessage(String email);
  String get rememberedPasswordPrompt;

  String get resetPasswordTitle;
  String resetPasswordSubtitle(String email);
  String get newPasswordLabel;
  String get resetPasswordAction;
  String get resettingPassword;
  String get passwordResetDone;
  String get feedbackResetPasswordTitle;
  String get passwordResetSuccessTitle;
  String get passwordResetSuccessMessage;
  String get linkExpiredPrompt;
  String get requestNewLink;

  String get navSectionWorkspace;
  String get navOverview;
  String get navAnalytics;
  String get soon;
  String get openNavigation;
  String welcomeBack(String name);
  String get homeSubtitle;
  String get accessTitle;
  String get signedInAsLabel;
  String get scopeCentral;
  String get scopeCentralDescription;
  String get scopeLaboratory;
  String get scopeLaboratoryDescription;
  String get scopeBranch;
  String get scopeBranchDescription;
  String get overviewEmptyTitle;
  String get overviewEmptyMessage;
  String get feedbackHomeTitle;
  String get accountMenuLabel;
  String get editProfile;
  String get changePassword;
  String get logOut;
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

  @override
  String get registerTitle => 'Create your laboratory';
  @override
  String get registerSubtitle =>
      'Register a laboratory account. You will verify your email before signing in.';
  @override
  String get nameLabel => 'Full name';
  @override
  String get nameHint => 'Ahmed Ali';
  @override
  String get nameRequired => 'Enter your full name.';
  @override
  String get nameTooLong => 'Name must be 255 characters or fewer.';
  @override
  String get newPasswordHint => 'At least 8 characters';
  @override
  String get passwordTooShort => 'Password must be at least 8 characters.';
  @override
  String get passwordConfirmationLabel => 'Confirm password';
  @override
  String get passwordConfirmationHint => 'Re-enter your password';
  @override
  String get passwordConfirmationRequired => 'Confirm your password.';
  @override
  String get passwordMismatch => 'Passwords do not match.';
  @override
  String get termsLabel => 'I agree to the Terms and Conditions';
  @override
  String get termsHint => 'Required to create an account';
  @override
  String get termsRequired =>
      'Accept the Terms and Conditions to continue.';
  @override
  String get createAccount => 'Create account';
  @override
  String get creatingAccount => 'Creating account…';
  @override
  String get accountCreated => 'Account created';
  @override
  String get feedbackRegisterTitle => 'Registration failed';
  @override
  String get registerSuccessTitle => 'Check your email';
  @override
  String registerSuccessMessage(String email) =>
      'We sent a verification code to $email. Verify your address to sign in.';
  @override
  String get signInPrompt => 'Already registered?';
  @override
  String get signInAction => 'Sign in';

  @override
  String get verificationTitle => 'Verify your email';
  @override
  String verificationSubtitle(String email) =>
      'Enter the 6-digit code we sent to $email.';
  @override
  String get codeLabel => 'Verification code';
  @override
  String get codeHint => '6-digit code';
  @override
  String get codeRequired => 'Enter the verification code.';
  @override
  String get codeLength => 'The code must be 6 digits.';
  @override
  String get verifying => 'Verifying…';
  @override
  String get verified => 'Verified';
  @override
  String get feedbackVerificationTitle => 'Verification failed';
  @override
  String get verificationSuccessTitle => 'Email verified';
  @override
  String get verificationSuccessMessage =>
      'Your account is active. You can now sign in.';
  @override
  String get verifiedPrompt => 'Already verified?';

  @override
  String get forgotPasswordTitle => 'Reset your password';
  @override
  String get forgotPasswordSubtitle =>
      "Enter your account email and we'll send you a link to choose a new password.";
  @override
  String get sendResetLink => 'Send reset link';
  @override
  String get sendingResetLink => 'Sending…';
  @override
  String get resetLinkSent => 'Link sent';
  @override
  String get feedbackForgotPasswordTitle => "Couldn't send the link";
  @override
  String get resetLinkSentTitle => 'Check your email';
  @override
  String resetLinkSentMessage(String email) =>
      'We sent a password reset link to $email. Open it to choose a new password.';
  @override
  String get rememberedPasswordPrompt => 'Remembered your password?';

  @override
  String get resetPasswordTitle => 'Choose a new password';
  @override
  String resetPasswordSubtitle(String email) =>
      'Set a new password for $email.';
  @override
  String get newPasswordLabel => 'New password';
  @override
  String get resetPasswordAction => 'Reset password';
  @override
  String get resettingPassword => 'Resetting…';
  @override
  String get passwordResetDone => 'Password reset';
  @override
  String get feedbackResetPasswordTitle => "Couldn't reset your password";
  @override
  String get passwordResetSuccessTitle => 'Password updated';
  @override
  String get passwordResetSuccessMessage =>
      'You can now sign in with your new password.';
  @override
  String get linkExpiredPrompt => 'Link expired?';
  @override
  String get requestNewLink => 'Request a new link';

  @override
  String get navSectionWorkspace => 'Workspace';
  @override
  String get navOverview => 'Overview';
  @override
  String get navAnalytics => 'Analytics';
  @override
  String get soon => 'Soon';
  @override
  String get openNavigation => 'Open navigation';
  @override
  String welcomeBack(String name) => 'Welcome back, $name';
  @override
  String get homeSubtitle =>
      "Here's an overview of your laboratory workspace.";
  @override
  String get accessTitle => 'Your access';
  @override
  String get signedInAsLabel => 'Signed in as';
  @override
  String get scopeCentral => 'Central administrator';
  @override
  String get scopeCentralDescription =>
      'You can see and manage every laboratory in the system.';
  @override
  String get scopeLaboratory => 'Laboratory administrator';
  @override
  String get scopeLaboratoryDescription =>
      'You manage your laboratories and all of their branches.';
  @override
  String get scopeBranch => 'Branch staff';
  @override
  String get scopeBranchDescription =>
      'Your access is limited to the branch you are assigned to.';
  @override
  String get overviewEmptyTitle => 'Nothing to summarise yet';
  @override
  String get overviewEmptyMessage =>
      'Summaries from your laboratories will appear here as new modules are added.';
  @override
  String get feedbackHomeTitle => "Couldn't load your account";
  @override
  String get accountMenuLabel => 'Account menu';
  @override
  String get editProfile => 'Edit profile';
  @override
  String get changePassword => 'Change password';
  @override
  String get logOut => 'Log out';
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

  @override
  String get registerTitle => 'أنشئ مختبرك';
  @override
  String get registerSubtitle =>
      'سجّل حساب مختبر جديد. ستحتاج إلى تأكيد بريدك الإلكتروني قبل تسجيل الدخول.';
  @override
  String get nameLabel => 'الاسم الكامل';
  @override
  String get nameHint => 'أحمد علي';
  @override
  String get nameRequired => 'أدخل اسمك الكامل.';
  @override
  String get nameTooLong => 'يجب ألا يزيد الاسم عن 255 حرفًا.';
  @override
  String get newPasswordHint => '8 أحرف على الأقل';
  @override
  String get passwordTooShort => 'يجب ألا تقل كلمة المرور عن 8 أحرف.';
  @override
  String get passwordConfirmationLabel => 'تأكيد كلمة المرور';
  @override
  String get passwordConfirmationHint => 'أعد إدخال كلمة المرور';
  @override
  String get passwordConfirmationRequired => 'أكّد كلمة المرور.';
  @override
  String get passwordMismatch => 'كلمتا المرور غير متطابقتين.';
  @override
  String get termsLabel => 'أوافق على الشروط والأحكام';
  @override
  String get termsHint => 'مطلوبة لإنشاء الحساب';
  @override
  String get termsRequired => 'وافق على الشروط والأحكام للمتابعة.';
  @override
  String get createAccount => 'إنشاء الحساب';
  @override
  String get creatingAccount => 'جارٍ إنشاء الحساب…';
  @override
  String get accountCreated => 'تم إنشاء الحساب';
  @override
  String get feedbackRegisterTitle => 'فشل إنشاء الحساب';
  @override
  String get registerSuccessTitle => 'تحقق من بريدك الإلكتروني';
  @override
  String registerSuccessMessage(String email) =>
      'أرسلنا رمز تأكيد إلى $email. أكّد بريدك لتتمكن من تسجيل الدخول.';
  @override
  String get signInPrompt => 'لديك حساب بالفعل؟';
  @override
  String get signInAction => 'تسجيل الدخول';

  @override
  String get verificationTitle => 'تأكيد بريدك الإلكتروني';
  @override
  String verificationSubtitle(String email) =>
      'أدخل الرمز المكوّن من 6 أرقام الذي أرسلناه إلى \u2066$email\u2069.';
  @override
  String get codeLabel => 'رمز التأكيد';
  @override
  String get codeHint => 'رمز من 6 أرقام';
  @override
  String get codeRequired => 'أدخل رمز التأكيد.';
  @override
  String get codeLength => 'يجب أن يتكون الرمز من 6 أرقام.';
  @override
  String get verifying => 'جارٍ التأكيد…';
  @override
  String get verified => 'تم التأكيد';
  @override
  String get feedbackVerificationTitle => 'فشل التأكيد';
  @override
  String get verificationSuccessTitle => 'تم تأكيد البريد الإلكتروني';
  @override
  String get verificationSuccessMessage =>
      'تم تفعيل حسابك. يمكنك الآن تسجيل الدخول.';
  @override
  String get verifiedPrompt => 'تم التأكيد بالفعل؟';

  @override
  String get forgotPasswordTitle => 'إعادة تعيين كلمة المرور';
  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريد حسابك وسنرسل لك رابطًا لاختيار كلمة مرور جديدة.';
  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';
  @override
  String get sendingResetLink => 'جارٍ الإرسال…';
  @override
  String get resetLinkSent => 'تم إرسال الرابط';
  @override
  String get feedbackForgotPasswordTitle => 'تعذّر إرسال الرابط';
  @override
  String get resetLinkSentTitle => 'تحقق من بريدك الإلكتروني';
  @override
  String resetLinkSentMessage(String email) =>
      'أرسلنا رابط إعادة تعيين كلمة المرور إلى \u2066$email\u2069. افتحه لاختيار كلمة مرور جديدة.';
  @override
  String get rememberedPasswordPrompt => 'تذكرت كلمة المرور؟';

  @override
  String get resetPasswordTitle => 'اختر كلمة مرور جديدة';
  @override
  String resetPasswordSubtitle(String email) =>
      'عيّن كلمة مرور جديدة للحساب \u2066$email\u2069.';
  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';
  @override
  String get resetPasswordAction => 'إعادة تعيين كلمة المرور';
  @override
  String get resettingPassword => 'جارٍ إعادة التعيين…';
  @override
  String get passwordResetDone => 'تمت إعادة التعيين';
  @override
  String get feedbackResetPasswordTitle => 'تعذّرت إعادة تعيين كلمة المرور';
  @override
  String get passwordResetSuccessTitle => 'تم تحديث كلمة المرور';
  @override
  String get passwordResetSuccessMessage =>
      'يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.';
  @override
  String get linkExpiredPrompt => 'انتهت صلاحية الرابط؟';
  @override
  String get requestNewLink => 'اطلب رابطًا جديدًا';

  @override
  String get navSectionWorkspace => 'مساحة العمل';
  @override
  String get navOverview => 'نظرة عامة';
  @override
  String get navAnalytics => 'التحليلات';
  @override
  String get soon => 'قريبًا';
  @override
  String get openNavigation => 'فتح القائمة';
  @override
  String welcomeBack(String name) => 'مرحبًا بعودتك، $name';
  @override
  String get homeSubtitle => 'إليك نظرة عامة على مساحة عمل مختبرك.';
  @override
  String get accessTitle => 'صلاحياتك';
  @override
  String get signedInAsLabel => 'تم تسجيل الدخول باسم';
  @override
  String get scopeCentral => 'مسؤول مركزي';
  @override
  String get scopeCentralDescription =>
      'يمكنك الاطلاع على جميع المختبرات في النظام وإدارتها.';
  @override
  String get scopeLaboratory => 'مسؤول المختبر';
  @override
  String get scopeLaboratoryDescription =>
      'تدير مختبراتك وجميع فروعها.';
  @override
  String get scopeBranch => 'فريق الفرع';
  @override
  String get scopeBranchDescription =>
      'تقتصر صلاحياتك على الفرع المعيَّن لك.';
  @override
  String get overviewEmptyTitle => 'لا يوجد ما يُلخَّص بعد';
  @override
  String get overviewEmptyMessage =>
      'ستظهر هنا ملخصات مختبراتك مع إضافة وحدات جديدة.';
  @override
  String get feedbackHomeTitle => 'تعذّر تحميل حسابك';
  @override
  String get accountMenuLabel => 'قائمة الحساب';
  @override
  String get editProfile => 'تعديل الملف الشخصي';
  @override
  String get changePassword => 'تغيير كلمة المرور';
  @override
  String get logOut => 'تسجيل الخروج';
}
