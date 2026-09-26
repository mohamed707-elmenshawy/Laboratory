import 'app_locale.dart';

abstract class AppStrings {
  const AppStrings();

  factory AppStrings.of(AppLocale locale) => switch (locale.code) {
    'ar' => const AppStringsAr(),
    _ => const AppStringsEn(),
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

  String get profileTitle;
  String get profileSubtitle;
  String get personalDetailsTitle;
  String get emailLockedHint;
  String get saveChanges;
  String get savingChanges;
  String get feedbackProfileTitle;
  String get feedbackProfileLoadTitle;
  String get profileUpdatedTitle;
  String get profileUpdatedMessage;
  String get phonesTitle;
  String get phonesSubtitle;
  String get phonesEmpty;
  String phonesCount(int count, int max);
  String phonesMaxReached(int max);
  String get addPhone;
  String get cancelPhone;
  String get phoneNumberLabel;
  String get phoneNumberHint;
  String get phoneCountryLabel;
  String get phoneTypeLabel;
  String get phoneRequired;
  String get phoneInvalid;
  String get phoneDuplicate;
  String phoneNumberOf(int position);
  String get phoneTypeBoth;
  String get phoneTypePhone;
  String get phoneTypeWhatsapp;
  String get changePasswordSubtitle;
  String get currentPasswordLabel;
  String get currentPasswordHint;
  String get currentPasswordRequired;
  String get updatePassword;
  String get updatingPassword;
  String get feedbackChangePasswordTitle;
  String get passwordChangedTitle;
  String get passwordChangedMessage;
  String get forgotCurrentPasswordTitle;
  String resetLinkExplainer(String email);
  String get emailMeResetLink;

  String get laboratoriesTitle;
  String get laboratoriesSubtitle;
  String get newLaboratory;
  String get laboratoryNameLabel;
  String get laboratoryNameHint;
  String get laboratoryAdminLabel;
  String get laboratoryBranchesLabel;
  String get laboratoryStatusLabel;
  String get laboratoryIdLabel;
  String get laboratoryActionsLabel;
  String get laboratoryAdminUnassigned;
  String get statusActive;
  String get statusInactive;
  String get view;
  String get edit;
  String get delete;
  String get cancel;
  String get close;
  String get refresh;
  String get perPage;
  String showingResults(int from, int to, int total);
  String get noResults;
  String get previousPage;
  String get nextPage;
  String pageNumber(int page);
  String get laboratoriesEmptyTitle;
  String get laboratoriesEmptyMessage;
  String get laboratoriesSearchHint;
  String get clearSearch;
  String get statusFilterLabel;
  String get statusFilterAll;
  String get clearFilters;
  String get laboratoriesNoMatchTitle;
  String get laboratoriesNoMatchMessage;
  String get feedbackLaboratoriesTitle;
  String get laboratoryDetailsTitle;
  String get laboratoryDetailsSubtitle;
  String laboratoryIdValue(int id);
  String get feedbackLaboratoryDetailsTitle;
  String get activate;
  String get deactivate;
  String get activating;
  String get deactivating;
  String get activateLaboratoryHint;
  String get deactivateLaboratoryHint;
  String get feedbackLaboratoryStatusTitle;
  String get feedbackActivateLaboratoryTitle;
  String get feedbackDeactivateLaboratoryTitle;
  String get laboratoryActivatedTitle;
  String get laboratoryActivatedMessage;
  String get laboratoryDeactivatedTitle;
  String get laboratoryDeactivatedMessage;
  String get createLaboratoryTitle;
  String get createLaboratorySubtitle;
  String get laboratoryNameRequired;
  String get creatingLaboratory;
  String get backToLaboratories;
  String get laboratoryNameLanguageLabel;
  String get laboratoryNameLanguageHint;
  String get feedbackCreateLaboratoryTitle;
  String get laboratoryCreatedTitle;
  String get laboratoryCreatedMessage;
  String get editLaboratoryTitle;
  String get deleteLaboratoryTitle;
  String deleteLaboratoryPrompt(String name);
  String get deleteLaboratoryHint;
  String get deletingLaboratory;
  String get deleteLaboratoryBranchesTitle;
  String deleteLaboratoryBranchesMessage(int count);
  String get feedbackDeleteLaboratoryTitle;
  String get laboratoryGone;
  String get laboratoryDeletedTitle;
  String get laboratoryDeletedMessage;
  String get uiOnlyTitle;
  String get uiOnlyMessage;
  String get create;
  String get save;
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
  String get termsRequired => 'Accept the Terms and Conditions to continue.';
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
  String get navOverview => 'Home';
  @override
  String get navAnalytics => 'Analytics';
  @override
  String get soon => 'Soon';
  @override
  String get openNavigation => 'Open navigation';
  @override
  String welcomeBack(String name) => 'Welcome back, $name';
  @override
  String get homeSubtitle => "Here's an overview of your laboratory workspace.";
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

  @override
  String get profileTitle => 'Profile';
  @override
  String get profileSubtitle => 'Manage the personal details on your account.';
  @override
  String get personalDetailsTitle => 'Personal details';
  @override
  String get emailLockedHint => "Your sign-in email can't be changed.";
  @override
  String get saveChanges => 'Save changes';
  @override
  String get savingChanges => 'Saving…';
  @override
  String get feedbackProfileTitle => "Couldn't update your profile";
  @override
  String get feedbackProfileLoadTitle => "Couldn't load your profile";
  @override
  String get profileUpdatedTitle => 'Profile updated';
  @override
  String get profileUpdatedMessage => 'Your changes have been saved.';
  @override
  String get phonesTitle => 'Phone numbers';
  @override
  String get phonesSubtitle =>
      'Numbers we can reach you on. Changes are saved with the form.';
  @override
  String phonesCount(int count, int max) => '$count of $max';
  @override
  String phonesMaxReached(int max) => 'You can save up to $max numbers.';
  @override
  String get addPhone => 'Add number';
  @override
  String get cancelPhone => 'Cancel this number';
  @override
  String get phoneNumberLabel => 'Phone number';
  @override
  String get phoneNumberHint => '01012345678';
  @override
  String get phoneCountryLabel => 'Country';
  @override
  String get phoneTypeLabel => 'Reachable on';
  @override
  String get phoneRequired => 'Enter a phone number.';
  @override
  String get phoneInvalid => 'Enter a valid phone number.';
  @override
  String get phoneDuplicate => 'This number is already in the list.';
  @override
  String phoneNumberOf(int position) => 'Phone number $position';
  @override
  String get phonesEmpty => 'No phone numbers on your account.';
  @override
  String get phoneTypeBoth => 'Calls & WhatsApp';
  @override
  String get phoneTypePhone => 'Calls';
  @override
  String get phoneTypeWhatsapp => 'WhatsApp';
  @override
  String get changePasswordSubtitle =>
      'Changing your password signs you out on your other devices.';
  @override
  String get currentPasswordLabel => 'Current password';
  @override
  String get currentPasswordHint => 'Enter your current password';
  @override
  String get currentPasswordRequired => 'Enter your current password.';
  @override
  String get updatePassword => 'Update password';
  @override
  String get updatingPassword => 'Updating…';
  @override
  String get feedbackChangePasswordTitle => "Couldn't change your password";
  @override
  String get passwordChangedTitle => 'Password changed';
  @override
  String get passwordChangedMessage =>
      'Your other devices have been signed out.';
  @override
  String get forgotCurrentPasswordTitle => 'Forgot your current password?';
  @override
  String resetLinkExplainer(String email) =>
      "We'll email a reset link to $email. Using it signs you out on every device.";
  @override
  String get emailMeResetLink => 'Email me a reset link';

  @override
  String get laboratoriesTitle => 'Laboratories';
  @override
  String get laboratoriesSubtitle =>
      'Every laboratory on the platform, with its admin and branches.';
  @override
  String get newLaboratory => 'New laboratory';
  @override
  String get laboratoryNameLabel => 'Laboratory name';
  @override
  String get laboratoryNameHint => 'Laboratory 1';
  @override
  String get laboratoryAdminLabel => 'Admin';
  @override
  String get laboratoryBranchesLabel => 'Branches';
  @override
  String get laboratoryStatusLabel => 'Status';
  @override
  String get laboratoryIdLabel => 'ID';
  @override
  String get laboratoryActionsLabel => 'Actions';
  @override
  String get laboratoryAdminUnassigned => 'Not assigned';
  @override
  String get statusActive => 'Active';
  @override
  String get statusInactive => 'Inactive';
  @override
  String get view => 'View';
  @override
  String get edit => 'Edit';
  @override
  String get delete => 'Delete';
  @override
  String get cancel => 'Cancel';
  @override
  String get close => 'Close';
  @override
  String get refresh => 'Refresh';
  @override
  String get perPage => 'Per page';
  @override
  String showingResults(int from, int to, int total) =>
      'Showing $from to $to of $total results';
  @override
  String get noResults => 'No results';
  @override
  String get previousPage => 'Previous page';
  @override
  String get nextPage => 'Next page';
  @override
  String pageNumber(int page) => 'Page $page';
  @override
  String get laboratoriesEmptyTitle => 'No laboratories yet';
  @override
  String get laboratoriesEmptyMessage =>
      'Laboratories you create will be listed here.';
  @override
  String get laboratoriesSearchHint => 'Search by laboratory name';
  @override
  String get clearSearch => 'Clear search';
  @override
  String get statusFilterLabel => 'Filter by status';
  @override
  String get statusFilterAll => 'All';
  @override
  String get clearFilters => 'Clear filters';
  @override
  String get laboratoriesNoMatchTitle => 'No matching laboratories';
  @override
  String get laboratoriesNoMatchMessage =>
      'Try a different name, or change the status filter.';
  @override
  String get feedbackLaboratoriesTitle => "Couldn't load laboratories";
  @override
  String get laboratoryDetailsTitle => 'Laboratory details';
  @override
  String get laboratoryDetailsSubtitle =>
      'Everything the platform knows about this laboratory.';
  @override
  String laboratoryIdValue(int id) => 'ID $id';
  @override
  String get feedbackLaboratoryDetailsTitle => "Couldn't load the laboratory";
  @override
  String get activate => 'Activate';
  @override
  String get deactivate => 'Deactivate';
  @override
  String get activating => 'Activating…';
  @override
  String get deactivating => 'Deactivating…';
  @override
  String get activateLaboratoryHint =>
      'An inactive laboratory stays on the platform but is closed for use.';
  @override
  String get deactivateLaboratoryHint =>
      'Deactivating closes this laboratory for use. Nothing is deleted.';
  @override
  String get feedbackLaboratoryStatusTitle =>
      "Couldn't change the laboratory status";
  @override
  String get feedbackActivateLaboratoryTitle =>
      "Couldn't activate the laboratory";
  @override
  String get feedbackDeactivateLaboratoryTitle =>
      "Couldn't deactivate the laboratory";
  @override
  String get laboratoryActivatedTitle => 'Laboratory activated';
  @override
  String get laboratoryActivatedMessage => 'It is open for use again.';
  @override
  String get laboratoryDeactivatedTitle => 'Laboratory deactivated';
  @override
  String get laboratoryDeactivatedMessage =>
      'It stays listed, but is closed for use.';
  @override
  String get createLaboratoryTitle => 'New laboratory';
  @override
  String get createLaboratorySubtitle =>
      'Add a laboratory to the platform. You can rename it later.';
  @override
  String get laboratoryNameRequired => 'Enter the laboratory name.';
  @override
  String get creatingLaboratory => 'Creating…';
  @override
  String get backToLaboratories => 'Back to laboratories';
  @override
  String get laboratoryNameLanguageLabel => 'Name language';
  @override
  String get laboratoryNameLanguageHint =>
      'The language this name is written in. Other languages can be added later.';
  @override
  String get feedbackCreateLaboratoryTitle => "Couldn't create the laboratory";
  @override
  String get laboratoryCreatedTitle => 'Laboratory created';
  @override
  String get laboratoryCreatedMessage => 'It is now listed below.';
  @override
  String get editLaboratoryTitle => 'Edit laboratory';
  @override
  String get deleteLaboratoryTitle => 'Delete laboratory';
  @override
  String deleteLaboratoryPrompt(String name) => 'Delete $name?';
  @override
  String get deleteLaboratoryHint =>
      'It moves to the trash, so an admin can still restore it.';
  @override
  String get deletingLaboratory => 'Deleting…';
  @override
  String get deleteLaboratoryBranchesTitle => 'Its branches go with it';
  @override
  String deleteLaboratoryBranchesMessage(int count) => count == 1
      ? 'The 1 branch in this laboratory is deleted too.'
      : 'All $count branches in this laboratory are deleted too.';
  @override
  String get feedbackDeleteLaboratoryTitle => "Couldn't delete the laboratory";
  @override
  String get laboratoryGone =>
      'This laboratory is no longer there. Refresh the list.';
  @override
  String get laboratoryDeletedTitle => 'Laboratory deleted';
  @override
  String get laboratoryDeletedMessage => 'It was moved to the trash.';
  @override
  String get uiOnlyTitle => 'Not connected yet';
  @override
  String get uiOnlyMessage =>
      'This screen is the interface only. The API for it is not wired up yet.';
  @override
  String get create => 'Create';
  @override
  String get save => 'Save';
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
  String get navOverview => 'الرئيسية';
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
  String get scopeLaboratoryDescription => 'تدير مختبراتك وجميع فروعها.';
  @override
  String get scopeBranch => 'فريق الفرع';
  @override
  String get scopeBranchDescription => 'تقتصر صلاحياتك على الفرع المعيَّن لك.';
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

  @override
  String get profileTitle => 'الملف الشخصي';
  @override
  String get profileSubtitle => 'أدِر البيانات الشخصية في حسابك.';
  @override
  String get personalDetailsTitle => 'البيانات الشخصية';
  @override
  String get emailLockedHint =>
      'لا يمكن تغيير البريد الإلكتروني المستخدم لتسجيل الدخول.';
  @override
  String get saveChanges => 'حفظ التغييرات';
  @override
  String get savingChanges => 'جارٍ الحفظ…';
  @override
  String get feedbackProfileTitle => 'تعذّر تحديث ملفك الشخصي';
  @override
  String get feedbackProfileLoadTitle => 'تعذّر تحميل ملفك الشخصي';
  @override
  String get profileUpdatedTitle => 'تم تحديث الملف الشخصي';
  @override
  String get profileUpdatedMessage => 'تم حفظ تغييراتك.';
  @override
  String get phonesTitle => 'أرقام الهاتف';
  @override
  String get phonesSubtitle =>
      'الأرقام التي يمكن التواصل معك عليها. تُحفظ مع النموذج.';
  @override
  String phonesCount(int count, int max) => '$count من $max';
  @override
  String phonesMaxReached(int max) => 'يمكنك حفظ $max أرقام كحد أقصى.';
  @override
  String get addPhone => 'إضافة رقم';
  @override
  String get cancelPhone => 'إلغاء هذا الرقم';
  @override
  String get phoneNumberLabel => 'رقم الهاتف';
  @override
  String get phoneNumberHint => '01012345678';
  @override
  String get phoneCountryLabel => 'الدولة';
  @override
  String get phoneTypeLabel => 'وسيلة التواصل';
  @override
  String get phoneRequired => 'أدخل رقم الهاتف.';
  @override
  String get phoneInvalid => 'أدخل رقم هاتف صحيح.';
  @override
  String get phoneDuplicate => 'هذا الرقم موجود بالفعل في القائمة.';
  @override
  String phoneNumberOf(int position) => 'رقم الهاتف $position';
  @override
  String get phonesEmpty => 'لا توجد أرقام هاتف في حسابك.';
  @override
  String get phoneTypeBoth => 'اتصال وواتساب';
  @override
  String get phoneTypePhone => 'اتصال';
  @override
  String get phoneTypeWhatsapp => 'واتساب';
  @override
  String get changePasswordSubtitle =>
      'يؤدي تغيير كلمة المرور إلى تسجيل خروجك من أجهزتك الأخرى.';
  @override
  String get currentPasswordLabel => 'كلمة المرور الحالية';
  @override
  String get currentPasswordHint => 'أدخل كلمة المرور الحالية';
  @override
  String get currentPasswordRequired => 'أدخل كلمة المرور الحالية.';
  @override
  String get updatePassword => 'تحديث كلمة المرور';
  @override
  String get updatingPassword => 'جارٍ التحديث…';
  @override
  String get feedbackChangePasswordTitle => 'تعذّر تغيير كلمة المرور';
  @override
  String get passwordChangedTitle => 'تم تغيير كلمة المرور';
  @override
  String get passwordChangedMessage => 'تم تسجيل خروجك من أجهزتك الأخرى.';
  @override
  String get forgotCurrentPasswordTitle => 'نسيت كلمة المرور الحالية؟';
  @override
  String resetLinkExplainer(String email) =>
      'سنرسل رابط إعادة التعيين إلى \u2066$email\u2069. استخدامه يسجّل خروجك من جميع الأجهزة.';
  @override
  String get emailMeResetLink => 'أرسل لي رابط إعادة التعيين';

  @override
  String get laboratoriesTitle => 'المعامل';
  @override
  String get laboratoriesSubtitle =>
      'كل المعامل على المنصة، ومسؤول كل معمل وفروعه.';
  @override
  String get newLaboratory => 'معمل جديد';
  @override
  String get laboratoryNameLabel => 'اسم المعمل';
  @override
  String get laboratoryNameHint => 'معمل 1';
  @override
  String get laboratoryAdminLabel => 'المسؤول';
  @override
  String get laboratoryBranchesLabel => 'الفروع';
  @override
  String get laboratoryStatusLabel => 'الحالة';
  @override
  String get laboratoryIdLabel => 'المعرّف';
  @override
  String get laboratoryActionsLabel => 'الإجراءات';
  @override
  String get laboratoryAdminUnassigned => 'غير محدد';
  @override
  String get statusActive => 'نشط';
  @override
  String get statusInactive => 'غير نشط';
  @override
  String get view => 'عرض';
  @override
  String get edit => 'تعديل';
  @override
  String get delete => 'حذف';
  @override
  String get cancel => 'إلغاء';
  @override
  String get close => 'إغلاق';
  @override
  String get refresh => 'تحديث';
  @override
  String get perPage => 'لكل صفحة';
  @override
  String showingResults(int from, int to, int total) =>
      'عرض $from إلى $to من $total نتيجة';
  @override
  String get noResults => 'لا توجد نتائج';
  @override
  String get previousPage => 'الصفحة السابقة';
  @override
  String get nextPage => 'الصفحة التالية';
  @override
  String pageNumber(int page) => 'صفحة $page';
  @override
  String get laboratoriesEmptyTitle => 'لا توجد معامل بعد';
  @override
  String get laboratoriesEmptyMessage => 'المعامل التي تنشئها ستظهر هنا.';
  @override
  String get laboratoriesSearchHint => 'ابحث باسم المعمل';
  @override
  String get clearSearch => 'مسح البحث';
  @override
  String get statusFilterLabel => 'تصفية حسب الحالة';
  @override
  String get statusFilterAll => 'الكل';
  @override
  String get clearFilters => 'مسح الفلاتر';
  @override
  String get laboratoriesNoMatchTitle => 'لا توجد معامل مطابقة';
  @override
  String get laboratoriesNoMatchMessage =>
      'جرّب اسمًا مختلفًا، أو غيّر فلتر الحالة.';
  @override
  String get feedbackLaboratoriesTitle => 'تعذّر تحميل المعامل';
  @override
  String get laboratoryDetailsTitle => 'بيانات المعمل';
  @override
  String get laboratoryDetailsSubtitle => 'كل ما تعرفه المنصة عن هذا المعمل.';
  @override
  String laboratoryIdValue(int id) => 'المعرّف $id';
  @override
  String get feedbackLaboratoryDetailsTitle => 'تعذّر تحميل بيانات المعمل';
  @override
  String get activate => 'تفعيل';
  @override
  String get deactivate => 'إيقاف';
  @override
  String get activating => 'جارٍ التفعيل…';
  @override
  String get deactivating => 'جارٍ الإيقاف…';
  @override
  String get activateLaboratoryHint =>
      'المعمل الموقوف يظل على المنصة لكنه مغلق للاستخدام.';
  @override
  String get deactivateLaboratoryHint =>
      'الإيقاف يغلق هذا المعمل للاستخدام، ولا يحذف أي شيء.';
  @override
  String get feedbackLaboratoryStatusTitle => 'تعذّر تغيير حالة المعمل';
  @override
  String get feedbackActivateLaboratoryTitle => 'تعذّر تفعيل المعمل';
  @override
  String get feedbackDeactivateLaboratoryTitle => 'تعذّر إيقاف المعمل';
  @override
  String get laboratoryActivatedTitle => 'تم تفعيل المعمل';
  @override
  String get laboratoryActivatedMessage => 'أصبح متاحًا للاستخدام من جديد.';
  @override
  String get laboratoryDeactivatedTitle => 'تم إيقاف المعمل';
  @override
  String get laboratoryDeactivatedMessage =>
      'يظل ظاهرًا في القائمة لكنه مغلق للاستخدام.';
  @override
  String get createLaboratoryTitle => 'معمل جديد';
  @override
  String get createLaboratorySubtitle =>
      'أضف معملًا إلى المنصة. يمكنك تغيير اسمه لاحقًا.';
  @override
  String get laboratoryNameRequired => 'أدخل اسم المعمل.';
  @override
  String get creatingLaboratory => 'جارٍ الإنشاء…';
  @override
  String get backToLaboratories => 'العودة إلى المعامل';
  @override
  String get laboratoryNameLanguageLabel => 'لغة الاسم';
  @override
  String get laboratoryNameLanguageHint =>
      'اللغة المكتوب بها هذا الاسم. يمكن إضافة لغات أخرى لاحقًا.';
  @override
  String get feedbackCreateLaboratoryTitle => 'تعذّر إنشاء المعمل';
  @override
  String get laboratoryCreatedTitle => 'تم إنشاء المعمل';
  @override
  String get laboratoryCreatedMessage => 'أصبح ظاهرًا في القائمة بالأسفل.';
  @override
  String get editLaboratoryTitle => 'تعديل المعمل';
  @override
  String get deleteLaboratoryTitle => 'حذف المعمل';
  @override
  String deleteLaboratoryPrompt(String name) => 'حذف $name؟';
  @override
  String get deleteLaboratoryHint =>
      'ينتقل إلى سلة المحذوفات، ويمكن لمسؤول استعادته.';
  @override
  String get deletingLaboratory => 'جارٍ الحذف…';
  @override
  String get deleteLaboratoryBranchesTitle => 'سيتم حذف فروعه أيضًا';
  @override
  String deleteLaboratoryBranchesMessage(int count) => count == 1
      ? 'سيتم حذف الفرع الموجود في هذا المعمل أيضًا.'
      : 'سيتم حذف جميع الفروع ($count) الموجودة في هذا المعمل أيضًا.';
  @override
  String get feedbackDeleteLaboratoryTitle => 'تعذّر حذف المعمل';
  @override
  String get laboratoryGone => 'هذا المعمل لم يعد موجودًا. حدّث القائمة.';
  @override
  String get laboratoryDeletedTitle => 'تم حذف المعمل';
  @override
  String get laboratoryDeletedMessage => 'تم نقله إلى سلة المحذوفات.';
  @override
  String get uiOnlyTitle => 'غير مربوط بعد';
  @override
  String get uiOnlyMessage =>
      'هذه الشاشة واجهة فقط، ولم يتم ربط الـ API الخاص بها بعد.';
  @override
  String get create => 'إنشاء';
  @override
  String get save => 'حفظ';
}
