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
  String get termsAgreePrefix;
  String get termsTitle;
  String get termsEmpty;
  String get feedbackTermsTitle;
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
  String get removePhone;
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

  String get newTestCategory;
  String get createTestCategoryTitle;
  String get createTestCategorySubtitle;
  String get editTestCategoryTitle;
  String get editTestCategorySubtitle;
  String get testCategoryNameRequired;
  String get testCategoryNameTooLong;
  String get testCategoryDescriptionTooLong;
  String get testCategoryBranchLabel;
  String get testCategoryBranchRequired;
  String get testCategoryBranchEmpty;
  String get creatingTestCategory;
  String get feedbackSaveTestCategoryTitle;
  String get testCategoryCreatedTitle;
  String get testCategoryCreatedMessage;
  String get testCategorySavedTitle;
  String get testCategorySavedMessage;
  String get testCategoryDetailsTitle;
  String get testCategoryDetailsSubtitle;
  String get backToTestCategories;
  String get feedbackTestCategoryDetailsTitle;
  String get feedbackDeleteTestCategoryTitle;
  String get deleteTestCategoryTitle;
  String deleteTestCategoryPrompt(String name);
  String get deleteTestCategoryHint;
  String get deletingTestCategory;
  String get testCategoryDeletedTitle;
  String get testCategoryDeletedMessage;
  String get testCategoryActivatedTitle;
  String get testCategoryActivatedMessage;
  String get testCategoryDeactivatedTitle;
  String get testCategoryDeactivatedMessage;
  String get feedbackTestCategoryStatusTitle;
  String get testCategoryGone;
  String get navTestCategories;
  String get testCategoriesTitle;
  String get testCategoriesSubtitle;
  String get testCategoryNameLabel;
  String get testCategoryDescriptionLabel;
  String get searchTestCategoriesHint;
  String get testCategoriesEmptyTitle;
  String get testCategoriesEmptyMessage;
  String get testCategoriesNoMatchTitle;
  String get testCategoriesNoMatchMessage;
  String get feedbackTestCategoriesTitle;

  String get newSampleType;
  String get createSampleTypeTitle;
  String get createSampleTypeSubtitle;
  String get editSampleTypeTitle;
  String get editSampleTypeSubtitle;
  String get sampleTypeNameRequired;
  String get sampleTypeNameTooLong;
  String get sampleTypeDescriptionTooLong;
  String get sampleTypeBranchLabel;
  String get sampleTypeBranchRequired;
  String get sampleTypeBranchEmpty;
  String get creatingSampleType;
  String get feedbackSaveSampleTypeTitle;
  String get sampleTypeCreatedTitle;
  String get sampleTypeCreatedMessage;
  String get sampleTypeSavedTitle;
  String get sampleTypeSavedMessage;
  String get sampleTypeDetailsTitle;
  String get sampleTypeDetailsSubtitle;
  String get backToSampleTypes;
  String get feedbackSampleTypeDetailsTitle;
  String get feedbackDeleteSampleTypeTitle;
  String get deleteSampleTypeTitle;
  String deleteSampleTypePrompt(String name);
  String get deleteSampleTypeHint;
  String get deletingSampleType;
  String get sampleTypeDeletedTitle;
  String get sampleTypeDeletedMessage;
  String get sampleTypeActivatedTitle;
  String get sampleTypeActivatedMessage;
  String get sampleTypeDeactivatedTitle;
  String get sampleTypeDeactivatedMessage;
  String get feedbackSampleTypeStatusTitle;
  String get sampleTypeGone;
  String get navSampleTypes;
  String get sampleTypesTitle;
  String get sampleTypesSubtitle;
  String get sampleTypeNameLabel;
  String get sampleTypeDescriptionLabel;
  String get searchSampleTypesHint;
  String get sampleTypesEmptyTitle;
  String get sampleTypesEmptyMessage;
  String get sampleTypesNoMatchTitle;
  String get sampleTypesNoMatchMessage;
  String get feedbackSampleTypesTitle;

  String get navParameters;
  String get parametersTitle;
  String get parametersSubtitle;
  String get newParameter;
  String get createParameterTitle;
  String get createParameterSubtitle;
  String get editParameterTitle;
  String get editParameterSubtitle;
  String get parameterNameLabel;
  String get parameterNameRequired;
  String get parameterNameTooLong;
  String get parameterDescriptionLabel;
  String get parameterDescriptionTooLong;
  String get parameterBranchLabel;
  String get parameterBranchRequired;
  String get parameterBranchEmpty;
  String get creatingParameter;
  String get feedbackSaveParameterTitle;
  String get parameterCreatedTitle;
  String get parameterCreatedMessage;
  String get parameterSavedTitle;
  String get parameterSavedMessage;
  String get parameterDetailsTitle;
  String get parameterDetailsSubtitle;
  String get backToParameters;
  String get feedbackParameterDetailsTitle;
  String get feedbackDeleteParameterTitle;
  String get deleteParameterTitle;
  String deleteParameterPrompt(String name);
  String get deleteParameterHint;
  String get deletingParameter;
  String get parameterDeletedTitle;
  String get parameterDeletedMessage;
  String get parameterActivatedTitle;
  String get parameterActivatedMessage;
  String get parameterDeactivatedTitle;
  String get parameterDeactivatedMessage;
  String get feedbackParameterStatusTitle;
  String get parameterGone;
  String get searchParametersHint;
  String get parametersEmptyTitle;
  String get parametersEmptyMessage;
  String get parametersNoMatchTitle;
  String get parametersNoMatchMessage;
  String get feedbackParametersTitle;

  String get newUnit;
  String get createUnitTitle;
  String get createUnitSubtitle;
  String get editUnitTitle;
  String get editUnitSubtitle;
  String get unitNameRequired;
  String get unitNameTooLong;
  String get unitSymbolRequired;
  String get unitSymbolTooLong;
  String get unitDescriptionTooLong;
  String get unitBranchLabel;
  String get unitBranchRequired;
  String get unitBranchEmpty;
  String get creatingUnit;
  String get feedbackSaveUnitTitle;
  String get unitCreatedTitle;
  String get unitCreatedMessage;
  String get unitSavedTitle;
  String get unitSavedMessage;
  String get unitDetailsTitle;
  String get unitDetailsSubtitle;
  String get backToUnits;
  String get feedbackUnitDetailsTitle;
  String get feedbackDeleteUnitTitle;
  String get deleteUnitTitle;
  String deleteUnitPrompt(String name);
  String get deleteUnitHint;
  String get deletingUnit;
  String get unitDeletedTitle;
  String get unitDeletedMessage;
  String get unitActivatedTitle;
  String get unitActivatedMessage;
  String get unitDeactivatedTitle;
  String get unitDeactivatedMessage;
  String get feedbackUnitStatusTitle;
  String get unitGone;
  String get navUnits;
  String get unitsTitle;
  String get unitsSubtitle;
  String get unitNameLabel;
  String get unitSymbolLabel;
  String get unitDescriptionLabel;
  String get searchUnitsHint;
  String get unitsEmptyTitle;
  String get unitsEmptyMessage;
  String get unitsNoMatchTitle;
  String get unitsNoMatchMessage;
  String get feedbackUnitsTitle;

  String get navUsers;
  String get usersTitle;
  String get usersSubtitle;
  String get newUser;
  String get createUserTitle;
  String get createUserSubtitle;
  String get editUserTitle;
  String get editUserSubtitle;
  String get userAccountSection;
  String get userAccessSection;
  String get userNameLabel;
  String get userNameRequired;
  String get userNameTooLong;
  String get userEmailLabel;
  String get userEmailTooLong;
  String get userPasswordLabel;
  String get userNewPasswordLabel;
  String get userPasswordKeepHint;
  String get userPasswordTooShort;
  String get userRolesLabel;
  String get userRolesHint;
  String get userRolesUnavailable;
  String get userBranchLabel;
  String get userBranchEmpty;
  String get userCommissionLabel;
  String get userCommissionRequired;
  String get userCommissionRange;
  String get userPermissionsLabel;
  String get userNoPermissions;
  String userPermissionsCount(int count);
  String get userNoPhones;
  String get userVerified;
  String get userUnverified;
  String get allRoles;
  String roleLabel(String name);
  String get creatingUser;
  String get feedbackSaveUserTitle;
  String get userCreatedTitle;
  String get userCreatedMessage;
  String get userSavedTitle;
  String get userSavedMessage;
  String get userDetailsTitle;
  String get userDetailsSubtitle;
  String get backToUsers;
  String get feedbackUserDetailsTitle;
  String get feedbackDeleteUserTitle;
  String get deleteUserTitle;
  String deleteUserPrompt(String name);
  String get deleteUserHint;
  String get deletingUser;
  String get userDeletedTitle;
  String get userDeletedMessage;
  String get userGone;
  String get searchUsersHint;
  String get usersEmptyTitle;
  String get usersEmptyMessage;
  String get usersNoMatchTitle;
  String get usersNoMatchMessage;
  String get feedbackUsersTitle;
  String userPermissionsSelected(int count);
  String get userPermissionsHint;
  String get userPermissionsUnavailable;
  String get searchPermissionsHint;
  String get permissionsNoMatch;
  String get selectAll;
  String get deselectAll;
  String get clearSelection;
  String get loadingPermissions;
  String get feedbackPermissionsTitle;
  String get feedbackPermissionsMessage;

  String get noDescription;
  String get navBranches;
  String get branchesTitle;
  String get branchesSubtitle;
  String get branchNameLabel;
  String get branchNameHint;
  String get branchNameRequired;
  String get branchNameTooLong;
  String get branchAddressLabel;
  String get branchAddressHint;
  String get branchAddressTooLong;
  String get branchLaboratoryLabel;
  String get branchLaboratoryRequired;
  String get branchManagerLabel;
  String get branchPhonesLabel;
  String get phonesEmptyShort;
  String get branchMainLabel;
  String get branchMainHint;
  String get branchMainPill;
  String get nameLanguageLabel;
  String get nameLanguageHint;
  String get notAssigned;
  String get searchBranchesHint;
  String get allLaboratories;
  String get branchesEmptyTitle;
  String get branchesEmptyMessage;
  String get branchesNoMatchTitle;
  String get branchesNoMatchMessage;
  String get feedbackBranchesTitle;
  String get feedbackBranchDetailsTitle;
  String get feedbackUpdateBranchTitle;
  String get feedbackDeleteBranchTitle;
  String get branchDetailsTitle;
  String get branchDetailsSubtitle;
  String get backToBranches;
  String get newBranch;
  String get createBranchTitle;
  String get createBranchSubtitle;
  String get creatingBranch;
  String get branchCreatedTitle;
  String get branchCreatedMessage;
  String get editBranch;
  String get editBranchTitle;
  String get editBranchSubtitle;
  String get branchUpdatedTitle;
  String get branchUpdatedMessage;
  String get deleteBranchTitle;
  String deleteBranchPrompt(String name);
  String get deleteBranchHint;
  String get deletingBranch;
  String get branchDeletedTitle;
  String get branchDeletedMessage;
  String get branchActivatedTitle;
  String get branchActivatedMessage;
  String get branchDeactivatedTitle;
  String get branchDeactivatedMessage;
  String get feedbackBranchStatusTitle;
  String get branchGone;
  String branchPhonesCount(int count);

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
  String get editLaboratorySubtitle;
  String get feedbackUpdateLaboratoryTitle;
  String get laboratoryUpdatedTitle;
  String get laboratoryUpdatedMessage;
  String get laboratoryLogoLabel;
  String get laboratoryLogoHint;
  String get chooseLogo;
  String get changeLogo;
  String get clearLogo;
  String get logoTooLarge;
  String get logoHint;
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
  String get termsAgreePrefix => 'I agree to the';
  @override
  String get termsTitle => 'Terms and Conditions';
  @override
  String get termsEmpty => 'No terms and conditions have been published yet.';
  @override
  String get feedbackTermsTitle => "Couldn't load the terms";
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
  String get removePhone => 'Remove this number';
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
  @override
  @override
  @override
  @override
  String get newTestCategory => 'New category';
  @override
  String get createTestCategoryTitle => 'New test category';
  @override
  String get createTestCategorySubtitle =>
      'Add a category to a branch of one of your laboratories.';
  @override
  String get editTestCategoryTitle => 'Edit category';
  @override
  String get editTestCategorySubtitle =>
      'Update the category details and where it belongs.';
  @override
  String get testCategoryNameRequired => 'Enter the category name.';
  @override
  String get testCategoryNameTooLong => 'Keep the name under 150 characters.';
  @override
  String get testCategoryDescriptionTooLong =>
      'Keep the description under 500 characters.';
  @override
  String get testCategoryBranchLabel => 'Branch';
  @override
  String get testCategoryBranchRequired => 'Choose a branch.';
  @override
  String get testCategoryBranchEmpty =>
      'This laboratory has no active branch. Activate one first.';
  @override
  String get creatingTestCategory => 'Creating…';
  @override
  String get feedbackSaveTestCategoryTitle => "Couldn't save the category";
  @override
  String get testCategoryCreatedTitle => 'Category created';
  @override
  String get testCategoryCreatedMessage => 'It is now listed below.';
  @override
  String get testCategorySavedTitle => 'Category saved';
  @override
  String get testCategorySavedMessage => 'Your changes are live.';
  @override
  String get testCategoryDetailsTitle => 'Category details';
  @override
  String get testCategoryDetailsSubtitle =>
      'Everything the platform knows about this test category.';
  @override
  String get backToTestCategories => 'Back to test categories';
  @override
  String get feedbackTestCategoryDetailsTitle => "Couldn't load the category";
  @override
  String get feedbackDeleteTestCategoryTitle => "Couldn't delete the category";
  @override
  String get deleteTestCategoryTitle => 'Delete category';
  @override
  String deleteTestCategoryPrompt(String name) => 'Delete $name?';
  @override
  String get deleteTestCategoryHint =>
      'It moves to the trash, so an admin can still restore it.';
  @override
  String get deletingTestCategory => 'Deleting…';
  @override
  String get testCategoryDeletedTitle => 'Category deleted';
  @override
  String get testCategoryDeletedMessage => 'It was moved to the trash.';
  @override
  String get testCategoryActivatedTitle => 'Category activated';
  @override
  String get testCategoryActivatedMessage => 'It is open for use again.';
  @override
  String get testCategoryDeactivatedTitle => 'Category deactivated';
  @override
  String get testCategoryDeactivatedMessage =>
      'It stays listed, but is closed for use.';
  @override
  String get feedbackTestCategoryStatusTitle =>
      "Couldn't change the category status";
  @override
  String get testCategoryGone =>
      'This category is no longer there. Refresh the list.';
  @override
  String get navTestCategories => 'Test categories';
  @override
  String get testCategoriesTitle => 'Test categories';
  @override
  String get testCategoriesSubtitle =>
      'The catalogue of test categories across your laboratories.';
  @override
  String get testCategoryNameLabel => 'Category';
  @override
  String get testCategoryDescriptionLabel => 'Description';
  @override
  String get searchTestCategoriesHint => 'Search by category name';
  @override
  String get testCategoriesEmptyTitle => 'No test categories yet';
  @override
  String get testCategoriesEmptyMessage =>
      'Categories you add to a branch are listed here.';
  @override
  String get testCategoriesNoMatchTitle => 'No categories match';
  @override
  String get testCategoriesNoMatchMessage =>
      'Try a different search or filter.';
  @override
  String get feedbackTestCategoriesTitle => "Couldn't load test categories";
  @override
  String get newSampleType => 'New sample type';
  @override
  String get createSampleTypeTitle => 'New sample type';
  @override
  String get createSampleTypeSubtitle =>
      'Add a sample type to a branch of one of your laboratories.';
  @override
  String get editSampleTypeTitle => 'Edit sample type';
  @override
  String get editSampleTypeSubtitle =>
      'Update the sample type details and where it belongs.';
  @override
  String get sampleTypeNameRequired => 'Enter the sample type name.';
  @override
  String get sampleTypeNameTooLong => 'Keep the name under 150 characters.';
  @override
  String get sampleTypeDescriptionTooLong =>
      'Keep the description under 500 characters.';
  @override
  String get sampleTypeBranchLabel => 'Branch';
  @override
  String get sampleTypeBranchRequired => 'Choose a branch.';
  @override
  String get sampleTypeBranchEmpty =>
      'This laboratory has no active branch. Activate one first.';
  @override
  String get creatingSampleType => 'Creating…';
  @override
  String get feedbackSaveSampleTypeTitle => "Couldn't save the sample type";
  @override
  String get sampleTypeCreatedTitle => 'Sample type created';
  @override
  String get sampleTypeCreatedMessage => 'It is now listed below.';
  @override
  String get sampleTypeSavedTitle => 'Sample type saved';
  @override
  String get sampleTypeSavedMessage => 'Your changes are live.';
  @override
  String get sampleTypeDetailsTitle => 'Sample type details';
  @override
  String get sampleTypeDetailsSubtitle =>
      'Everything the platform knows about this sample type.';
  @override
  String get backToSampleTypes => 'Back to sample types';
  @override
  String get feedbackSampleTypeDetailsTitle => "Couldn't load the sample type";
  @override
  String get feedbackDeleteSampleTypeTitle => "Couldn't delete the sample type";
  @override
  String get deleteSampleTypeTitle => 'Delete sample type';
  @override
  String deleteSampleTypePrompt(String name) => 'Delete $name?';
  @override
  String get deleteSampleTypeHint =>
      'It moves to the trash, so an admin can still restore it.';
  @override
  String get deletingSampleType => 'Deleting…';
  @override
  String get sampleTypeDeletedTitle => 'Sample type deleted';
  @override
  String get sampleTypeDeletedMessage => 'It was moved to the trash.';
  @override
  String get sampleTypeActivatedTitle => 'Sample type activated';
  @override
  String get sampleTypeActivatedMessage => 'It is open for use again.';
  @override
  String get sampleTypeDeactivatedTitle => 'Sample type deactivated';
  @override
  String get sampleTypeDeactivatedMessage =>
      'It stays listed, but is closed for use.';
  @override
  String get feedbackSampleTypeStatusTitle =>
      "Couldn't change the sample type status";
  @override
  String get sampleTypeGone =>
      'This sample type is no longer there. Refresh the list.';
  @override
  String get navSampleTypes => 'Sample types';
  @override
  String get sampleTypesTitle => 'Sample types';
  @override
  String get sampleTypesSubtitle =>
      'The catalogue of sample types across your laboratories.';
  @override
  String get sampleTypeNameLabel => 'Sample type';
  @override
  String get sampleTypeDescriptionLabel => 'Description';
  @override
  String get searchSampleTypesHint => 'Search by sample type name';
  @override
  String get sampleTypesEmptyTitle => 'No sample types yet';
  @override
  String get sampleTypesEmptyMessage =>
      'Sample types you add to a branch are listed here.';
  @override
  String get sampleTypesNoMatchTitle => 'No sample types match';
  @override
  String get sampleTypesNoMatchMessage => 'Try a different search or filter.';
  @override
  String get feedbackSampleTypesTitle => "Couldn't load sample types";
  @override
  String get navParameters => 'Parameters';
  @override
  String get parametersTitle => 'Parameters';
  @override
  String get parametersSubtitle =>
      'The measurements your tests report, across your laboratories.';
  @override
  String get newParameter => 'New parameter';
  @override
  String get createParameterTitle => 'New parameter';
  @override
  String get createParameterSubtitle =>
      'Add a parameter to a branch of one of your laboratories.';
  @override
  String get editParameterTitle => 'Edit parameter';
  @override
  String get editParameterSubtitle =>
      'Update the parameter details and where it belongs.';
  @override
  String get parameterNameLabel => 'Parameter';
  @override
  String get parameterNameRequired => 'Enter the parameter name.';
  @override
  String get parameterNameTooLong => 'Keep the name under 150 characters.';
  @override
  String get parameterDescriptionLabel => 'Description';
  @override
  String get parameterDescriptionTooLong =>
      'Keep the description under 500 characters.';
  @override
  String get parameterBranchLabel => 'Branch';
  @override
  String get parameterBranchRequired => 'Choose a branch.';
  @override
  String get parameterBranchEmpty =>
      'This laboratory has no active branch. Activate one first.';
  @override
  String get creatingParameter => 'Creating…';
  @override
  String get feedbackSaveParameterTitle => "Couldn't save the parameter";
  @override
  String get parameterCreatedTitle => 'Parameter created';
  @override
  String get parameterCreatedMessage => 'It is now listed below.';
  @override
  String get parameterSavedTitle => 'Parameter saved';
  @override
  String get parameterSavedMessage => 'Your changes are live.';
  @override
  String get parameterDetailsTitle => 'Parameter details';
  @override
  String get parameterDetailsSubtitle =>
      'Everything the platform knows about this parameter.';
  @override
  String get backToParameters => 'Back to parameters';
  @override
  String get feedbackParameterDetailsTitle => "Couldn't load the parameter";
  @override
  String get feedbackDeleteParameterTitle => "Couldn't delete the parameter";
  @override
  String get deleteParameterTitle => 'Delete parameter';
  @override
  String deleteParameterPrompt(String name) => 'Delete $name?';
  @override
  String get deleteParameterHint =>
      'It moves to the trash, so an admin can still restore it.';
  @override
  String get deletingParameter => 'Deleting…';
  @override
  String get parameterDeletedTitle => 'Parameter deleted';
  @override
  String get parameterDeletedMessage => 'It was moved to the trash.';
  @override
  String get parameterActivatedTitle => 'Parameter activated';
  @override
  String get parameterActivatedMessage => 'It is open for use again.';
  @override
  String get parameterDeactivatedTitle => 'Parameter deactivated';
  @override
  String get parameterDeactivatedMessage =>
      'It stays listed, but is closed for use.';
  @override
  String get feedbackParameterStatusTitle =>
      "Couldn't change the parameter status";
  @override
  String get parameterGone =>
      'This parameter is no longer there. Refresh the list.';
  @override
  String get searchParametersHint => 'Search by parameter name';
  @override
  String get parametersEmptyTitle => 'No parameters yet';
  @override
  String get parametersEmptyMessage =>
      'Parameters you add to a branch are listed here.';
  @override
  String get parametersNoMatchTitle => 'No parameters match';
  @override
  String get parametersNoMatchMessage => 'Try a different search or filter.';
  @override
  String get feedbackParametersTitle => "Couldn't load parameters";
  @override
  String get newUnit => 'New unit';
  @override
  String get createUnitTitle => 'New unit';
  @override
  String get createUnitSubtitle =>
      'Add a unit to a branch of one of your laboratories.';
  @override
  String get editUnitTitle => 'Edit unit';
  @override
  String get editUnitSubtitle =>
      'Update the unit details and where it belongs.';
  @override
  String get unitNameRequired => 'Enter the unit name.';
  @override
  String get unitNameTooLong => 'Keep the name under 150 characters.';
  @override
  String get unitSymbolRequired => 'Enter the unit symbol.';
  @override
  String get unitSymbolTooLong => 'Keep the symbol under 50 characters.';
  @override
  String get unitDescriptionTooLong =>
      'Keep the description under 500 characters.';
  @override
  String get unitBranchLabel => 'Branch';
  @override
  String get unitBranchRequired => 'Choose a branch.';
  @override
  String get unitBranchEmpty =>
      'This laboratory has no active branch. Activate one first.';
  @override
  String get creatingUnit => 'Creating…';
  @override
  String get feedbackSaveUnitTitle => "Couldn't save the unit";
  @override
  String get unitCreatedTitle => 'Unit created';
  @override
  String get unitCreatedMessage => 'It is now listed below.';
  @override
  String get unitSavedTitle => 'Unit saved';
  @override
  String get unitSavedMessage => 'Your changes are live.';
  @override
  String get unitDetailsTitle => 'Unit details';
  @override
  String get unitDetailsSubtitle =>
      'Everything the platform knows about this unit.';
  @override
  String get backToUnits => 'Back to units';
  @override
  String get feedbackUnitDetailsTitle => "Couldn't load the unit";
  @override
  String get feedbackDeleteUnitTitle => "Couldn't delete the unit";
  @override
  String get deleteUnitTitle => 'Delete unit';
  @override
  String deleteUnitPrompt(String name) => 'Delete $name?';
  @override
  String get deleteUnitHint =>
      'It moves to the trash, so an admin can still restore it.';
  @override
  String get deletingUnit => 'Deleting…';
  @override
  String get unitDeletedTitle => 'Unit deleted';
  @override
  String get unitDeletedMessage => 'It was moved to the trash.';
  @override
  String get unitActivatedTitle => 'Unit activated';
  @override
  String get unitActivatedMessage => 'It is open for use again.';
  @override
  String get unitDeactivatedTitle => 'Unit deactivated';
  @override
  String get unitDeactivatedMessage =>
      'It stays listed, but is closed for use.';
  @override
  String get feedbackUnitStatusTitle => "Couldn't change the unit status";
  @override
  String get unitGone => 'This unit is no longer there. Refresh the list.';
  @override
  String get navUnits => 'Units';
  @override
  String get unitsTitle => 'Units';
  @override
  String get unitsSubtitle =>
      'The catalogue of measurement units across your laboratories.';
  @override
  String get unitNameLabel => 'Unit';
  @override
  String get unitSymbolLabel => 'Symbol';
  @override
  String get unitDescriptionLabel => 'Description';
  @override
  String get searchUnitsHint => 'Search by unit name';
  @override
  String get unitsEmptyTitle => 'No units yet';
  @override
  String get unitsEmptyMessage => 'Units you add to a branch are listed here.';
  @override
  String get unitsNoMatchTitle => 'No units match';
  @override
  String get unitsNoMatchMessage => 'Try a different search or filter.';
  @override
  String get feedbackUnitsTitle => "Couldn't load units";
  @override
  String get navUsers => 'Users';
  @override
  String get usersTitle => 'Users';
  @override
  String get usersSubtitle => 'Everyone with access to the platform.';
  @override
  String get newUser => 'New user';
  @override
  String get createUserTitle => 'New user';
  @override
  String get createUserSubtitle =>
      'Create an account and choose what it can reach.';
  @override
  String get editUserTitle => 'Edit user';
  @override
  String get editUserSubtitle => 'Update the account details and its access.';
  @override
  String get userAccountSection => 'Account';
  @override
  String get userAccessSection => 'Access';
  @override
  String get userNameLabel => 'Full name';
  @override
  String get userNameRequired => 'Enter the full name.';
  @override
  String get userNameTooLong => 'Keep the name under 30 characters.';
  @override
  String get userEmailLabel => 'Email address';
  @override
  String get userEmailTooLong => 'Keep the email under 100 characters.';
  @override
  String get userPasswordLabel => 'Password';
  @override
  String get userNewPasswordLabel => 'New password';
  @override
  String get userPasswordKeepHint =>
      'Leave empty to keep the current password.';
  @override
  String get userPasswordTooShort => 'Use at least 8 characters.';
  @override
  String get userRolesLabel => 'Roles';
  @override
  String get userRolesHint =>
      'The role decides where the account lives and what it can reach.';
  @override
  String get userRolesUnavailable => 'You cannot assign any role.';
  @override
  String get userBranchLabel => 'Branch';
  @override
  String get userBranchEmpty =>
      'This laboratory has no active branch. Activate one first.';
  @override
  String get userCommissionLabel => 'Commission %';
  @override
  String get userCommissionRequired =>
      'A commission is required for team members.';
  @override
  String get userCommissionRange => 'Enter a number between 1 and 100.';
  @override
  String get userPermissionsLabel => 'Permissions';
  @override
  String get userNoPermissions => 'No permissions';
  @override
  String userPermissionsCount(int count) => '$count permissions';
  @override
  String get userNoPhones => 'No phone numbers yet.';
  @override
  String get userVerified => 'Verified';
  @override
  String get userUnverified => 'Not verified';
  @override
  String get allRoles => 'All roles';
  @override
  String roleLabel(String name) => switch (name) {
    'super-admin' => 'Super admin',
    'team-member' => 'Team member',
    'laboratory-admin' => 'Laboratory admin',
    'branch-manager' => 'Branch manager',
    'doctor' => 'Doctor',
    'receptionist' => 'Receptionist',
    _ => name,
  };
  @override
  String get creatingUser => 'Creating…';
  @override
  String get feedbackSaveUserTitle => "Couldn't save the user";
  @override
  String get userCreatedTitle => 'User created';
  @override
  String get userCreatedMessage => 'The account is ready to sign in.';
  @override
  String get userSavedTitle => 'User saved';
  @override
  String get userSavedMessage => 'Your changes are live.';
  @override
  String get userDetailsTitle => 'User details';
  @override
  String get userDetailsSubtitle =>
      'Everything the platform knows about this account.';
  @override
  String get backToUsers => 'Back to users';
  @override
  String get feedbackUserDetailsTitle => "Couldn't load the user";
  @override
  String get feedbackDeleteUserTitle => "Couldn't delete the user";
  @override
  String get deleteUserTitle => 'Delete user';
  @override
  String deleteUserPrompt(String name) => 'Delete $name?';
  @override
  String get deleteUserHint =>
      'It moves to the trash, so an admin can still restore it.';
  @override
  String get deletingUser => 'Deleting…';
  @override
  String get userDeletedTitle => 'User deleted';
  @override
  String get userDeletedMessage => 'It was moved to the trash.';
  @override
  String get userGone => 'This user is no longer there. Refresh the list.';
  @override
  String get searchUsersHint => 'Search by name or email';
  @override
  String get usersEmptyTitle => 'No users yet';
  @override
  String get usersEmptyMessage => 'Accounts you create are listed here.';
  @override
  String get usersNoMatchTitle => 'No users match';
  @override
  String get usersNoMatchMessage => 'Try a different search or filter.';
  @override
  String get feedbackUsersTitle => "Couldn't load users";
  @override
  String userPermissionsSelected(int count) => '$count selected';
  @override
  String get userPermissionsHint =>
      'Extra permissions on top of the role. You can only grant what you hold yourself.';
  @override
  String get userPermissionsUnavailable =>
      'You hold no permissions to pass on.';
  @override
  String get searchPermissionsHint => 'Search permissions';
  @override
  String get permissionsNoMatch => 'No permission matches this search.';
  @override
  String get selectAll => 'Select all';
  @override
  String get deselectAll => 'Clear all';
  @override
  String get clearSelection => 'Clear';
  @override
  String get loadingPermissions => 'Loading permissions…';
  @override
  String get feedbackPermissionsTitle => "Couldn't load the permissions";
  @override
  String get feedbackPermissionsMessage =>
      'The account can still be saved without extra permissions.';
  @override
  String get noDescription => 'No description';
  @override
  String get navBranches => 'Branches';
  @override
  String get branchesTitle => 'Branches';
  @override
  String get branchesSubtitle =>
      'Every branch across your laboratories, with its contacts.';
  @override
  String get branchNameLabel => 'Branch name';
  @override
  String get branchNameHint => 'Downtown branch';
  @override
  String get branchNameRequired => 'Enter the branch name.';
  @override
  String get branchNameTooLong => 'Keep the name under 150 characters.';
  @override
  String get branchAddressLabel => 'Address';
  @override
  String get branchAddressHint => 'Street, city';
  @override
  String get branchAddressTooLong => 'Keep the address under 500 characters.';
  @override
  String get branchLaboratoryLabel => 'Laboratory';
  @override
  String get branchLaboratoryRequired => 'Choose a laboratory.';
  @override
  String get branchManagerLabel => 'Manager';
  @override
  String get branchPhonesLabel => 'Phone numbers';
  @override
  String get phonesEmptyShort => 'No numbers';
  @override
  String get branchMainLabel => 'Main branch';
  @override
  String get branchMainHint =>
      'The main branch of a laboratory. Setting it here clears it from the others.';
  @override
  String get branchMainPill => 'Main';
  @override
  String get nameLanguageLabel => 'Name language';
  @override
  String get nameLanguageHint =>
      'The language this name and address are written in.';
  @override
  String get notAssigned => 'Not assigned';
  @override
  String get searchBranchesHint => 'Search by branch name';
  @override
  String get allLaboratories => 'All laboratories';
  @override
  String get branchesEmptyTitle => 'No branches yet';
  @override
  String get branchesEmptyMessage =>
      'Branches you add to a laboratory are listed here.';
  @override
  String get branchesNoMatchTitle => 'No branches match';
  @override
  String get branchesNoMatchMessage => 'Try a different search or filter.';
  @override
  String get feedbackBranchesTitle => "Couldn't load branches";
  @override
  String get feedbackBranchDetailsTitle => "Couldn't load the branch";
  @override
  String get feedbackUpdateBranchTitle => "Couldn't save the branch";
  @override
  String get feedbackDeleteBranchTitle => "Couldn't delete the branch";
  @override
  String get branchDetailsTitle => 'Branch details';
  @override
  String get branchDetailsSubtitle =>
      'Everything the platform knows about this branch.';
  @override
  String get backToBranches => 'Back to branches';
  @override
  String get newBranch => 'New branch';
  @override
  String get createBranchTitle => 'New branch';
  @override
  String get createBranchSubtitle =>
      'Add a branch to one of your laboratories.';
  @override
  String get creatingBranch => 'Creating…';
  @override
  String get branchCreatedTitle => 'Branch created';
  @override
  String get branchCreatedMessage => 'It is now listed below.';
  @override
  String get editBranch => 'Edit branch';
  @override
  String get editBranchTitle => 'Edit branch';
  @override
  String get editBranchSubtitle =>
      'Update the branch details, its laboratory and its contacts.';
  @override
  String get branchUpdatedTitle => 'Branch saved';
  @override
  String get branchUpdatedMessage => 'Your changes are live.';
  @override
  String get deleteBranchTitle => 'Delete branch';
  @override
  String deleteBranchPrompt(String name) => 'Delete $name?';
  @override
  String get deleteBranchHint =>
      'It moves to the trash, so an admin can still restore it.';
  @override
  String get deletingBranch => 'Deleting…';
  @override
  String get branchDeletedTitle => 'Branch deleted';
  @override
  String get branchDeletedMessage => 'It was moved to the trash.';
  @override
  String get branchActivatedTitle => 'Branch activated';
  @override
  String get branchActivatedMessage => 'It is open for use again.';
  @override
  String get branchDeactivatedTitle => 'Branch deactivated';
  @override
  String get branchDeactivatedMessage =>
      'It stays listed, but is closed for use.';
  @override
  String get feedbackBranchStatusTitle => "Couldn't change the branch status";
  @override
  String get branchGone => 'This branch is no longer there. Refresh the list.';
  @override
  String branchPhonesCount(int count) =>
      count == 1 ? '1 number' : '$count numbers';

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
  String get editLaboratorySubtitle =>
      'Change the name or logo. The name is saved in the language you pick.';
  @override
  String get feedbackUpdateLaboratoryTitle => "Couldn't update the laboratory";
  @override
  String get laboratoryUpdatedTitle => 'Laboratory updated';
  @override
  String get laboratoryUpdatedMessage => 'The new details are saved.';
  @override
  String get laboratoryLogoLabel => 'Logo';
  @override
  String get laboratoryLogoHint =>
      'Optional. Shown anywhere this laboratory appears.';
  @override
  String get chooseLogo => 'Choose logo';
  @override
  String get changeLogo => 'Change logo';
  @override
  String get clearLogo => 'Remove logo';
  @override
  String get logoTooLarge => 'Pick a PNG or JPG under 2 MB.';
  @override
  String get logoHint => 'PNG or JPG, up to 2 MB.';
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
  String get termsAgreePrefix => 'أوافق على';
  @override
  String get termsTitle => 'الشروط والأحكام';
  @override
  String get termsEmpty => 'لم يتم نشر أي شروط وأحكام بعد.';
  @override
  String get feedbackTermsTitle => 'تعذّر تحميل الشروط والأحكام';
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
  String get removePhone => 'حذف هذا الرقم';
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
  @override
  @override
  @override
  @override
  String get newTestCategory => 'فئة جديدة';
  @override
  String get createTestCategoryTitle => 'فئة تحاليل جديدة';
  @override
  String get createTestCategorySubtitle => 'أضف فئة إلى فرع في أحد معاملك.';
  @override
  String get editTestCategoryTitle => 'تعديل الفئة';
  @override
  String get editTestCategorySubtitle => 'عدّل بيانات الفئة ومكانها.';
  @override
  String get testCategoryNameRequired => 'أدخل اسم الفئة.';
  @override
  String get testCategoryNameTooLong => 'اجعل الاسم أقل من 150 حرفًا.';
  @override
  String get testCategoryDescriptionTooLong => 'اجعل الوصف أقل من 500 حرف.';
  @override
  String get testCategoryBranchLabel => 'الفرع';
  @override
  String get testCategoryBranchRequired => 'اختر الفرع.';
  @override
  String get testCategoryBranchEmpty =>
      'لا يوجد فرع نشط في هذا المعمل. فعّل فرعًا أولًا.';
  @override
  String get creatingTestCategory => 'جارٍ الإنشاء…';
  @override
  String get feedbackSaveTestCategoryTitle => 'تعذّر حفظ الفئة';
  @override
  String get testCategoryCreatedTitle => 'تم إنشاء الفئة';
  @override
  String get testCategoryCreatedMessage => 'أصبحت ظاهرة في القائمة بالأسفل.';
  @override
  String get testCategorySavedTitle => 'تم حفظ الفئة';
  @override
  String get testCategorySavedMessage => 'تم تطبيق تعديلاتك.';
  @override
  String get testCategoryDetailsTitle => 'بيانات الفئة';
  @override
  String get testCategoryDetailsSubtitle => 'كل ما تعرفه المنصة عن هذه الفئة.';
  @override
  String get backToTestCategories => 'العودة إلى فئات التحاليل';
  @override
  String get feedbackTestCategoryDetailsTitle => 'تعذّر تحميل بيانات الفئة';
  @override
  String get feedbackDeleteTestCategoryTitle => 'تعذّر حذف الفئة';
  @override
  String get deleteTestCategoryTitle => 'حذف الفئة';
  @override
  String deleteTestCategoryPrompt(String name) => 'حذف $name؟';
  @override
  String get deleteTestCategoryHint =>
      'تنتقل إلى سلة المحذوفات، ويمكن لمسؤول استعادتها.';
  @override
  String get deletingTestCategory => 'جارٍ الحذف…';
  @override
  String get testCategoryDeletedTitle => 'تم حذف الفئة';
  @override
  String get testCategoryDeletedMessage => 'تم نقلها إلى سلة المحذوفات.';
  @override
  String get testCategoryActivatedTitle => 'تم تفعيل التصنيف';
  @override
  String get testCategoryActivatedMessage => 'أصبح متاحًا للاستخدام من جديد.';
  @override
  String get testCategoryDeactivatedTitle => 'تم إيقاف التصنيف';
  @override
  String get testCategoryDeactivatedMessage =>
      'يظل ظاهرًا في القائمة لكنه مغلق للاستخدام.';
  @override
  String get feedbackTestCategoryStatusTitle => 'تعذّر تغيير حالة التصنيف';
  @override
  String get testCategoryGone => 'هذه الفئة لم تعد موجودة. حدّث القائمة.';
  @override
  String get navTestCategories => 'فئات التحاليل';
  @override
  String get testCategoriesTitle => 'فئات التحاليل';
  @override
  String get testCategoriesSubtitle => 'دليل فئات التحاليل في معاملك.';
  @override
  String get testCategoryNameLabel => 'الفئة';
  @override
  String get testCategoryDescriptionLabel => 'الوصف';
  @override
  String get searchTestCategoriesHint => 'ابحث باسم الفئة';
  @override
  String get testCategoriesEmptyTitle => 'لا توجد فئات تحاليل بعد';
  @override
  String get testCategoriesEmptyMessage =>
      'الفئات التي تضيفها إلى فرع ستظهر هنا.';
  @override
  String get testCategoriesNoMatchTitle => 'لا توجد فئات مطابقة';
  @override
  String get testCategoriesNoMatchMessage => 'جرّب بحثًا أو تصفية مختلفة.';
  @override
  String get feedbackTestCategoriesTitle => 'تعذّر تحميل فئات التحاليل';
  @override
  String get newSampleType => 'نوع عينة جديد';
  @override
  String get createSampleTypeTitle => 'نوع عينة جديد';
  @override
  String get createSampleTypeSubtitle => 'أضف نوع عينة إلى فرع في أحد معاملك.';
  @override
  String get editSampleTypeTitle => 'تعديل نوع العينة';
  @override
  String get editSampleTypeSubtitle => 'عدّل بيانات نوع العينة ومكانه.';
  @override
  String get sampleTypeNameRequired => 'أدخل اسم نوع العينة.';
  @override
  String get sampleTypeNameTooLong => 'اجعل الاسم أقل من 150 حرفًا.';
  @override
  String get sampleTypeDescriptionTooLong => 'اجعل الوصف أقل من 500 حرف.';
  @override
  String get sampleTypeBranchLabel => 'الفرع';
  @override
  String get sampleTypeBranchRequired => 'اختر الفرع.';
  @override
  String get sampleTypeBranchEmpty =>
      'لا يوجد فرع نشط في هذا المعمل. فعّل فرعًا أولًا.';
  @override
  String get creatingSampleType => 'جارٍ الإنشاء…';
  @override
  String get feedbackSaveSampleTypeTitle => 'تعذّر حفظ نوع العينة';
  @override
  String get sampleTypeCreatedTitle => 'تم إنشاء نوع العينة';
  @override
  String get sampleTypeCreatedMessage => 'أصبح ظاهرًا في القائمة بالأسفل.';
  @override
  String get sampleTypeSavedTitle => 'تم حفظ نوع العينة';
  @override
  String get sampleTypeSavedMessage => 'تم تطبيق تعديلاتك.';
  @override
  String get sampleTypeDetailsTitle => 'بيانات نوع العينة';
  @override
  String get sampleTypeDetailsSubtitle =>
      'كل ما تعرفه المنصة عن نوع العينة هذا.';
  @override
  String get backToSampleTypes => 'العودة إلى أنواع العينات';
  @override
  String get feedbackSampleTypeDetailsTitle => 'تعذّر تحميل بيانات نوع العينة';
  @override
  String get feedbackDeleteSampleTypeTitle => 'تعذّر حذف نوع العينة';
  @override
  String get deleteSampleTypeTitle => 'حذف نوع العينة';
  @override
  String deleteSampleTypePrompt(String name) => 'حذف $name؟';
  @override
  String get deleteSampleTypeHint =>
      'ينتقل إلى سلة المحذوفات، ويمكن لمسؤول استعادته.';
  @override
  String get deletingSampleType => 'جارٍ الحذف…';
  @override
  String get sampleTypeDeletedTitle => 'تم حذف نوع العينة';
  @override
  String get sampleTypeDeletedMessage => 'تم نقله إلى سلة المحذوفات.';
  @override
  String get sampleTypeActivatedTitle => 'تم تفعيل نوع العينة';
  @override
  String get sampleTypeActivatedMessage => 'أصبح متاحًا للاستخدام من جديد.';
  @override
  String get sampleTypeDeactivatedTitle => 'تم إيقاف نوع العينة';
  @override
  String get sampleTypeDeactivatedMessage =>
      'يظل ظاهرًا في القائمة لكنه مغلق للاستخدام.';
  @override
  String get feedbackSampleTypeStatusTitle => 'تعذّر تغيير حالة نوع العينة';
  @override
  String get sampleTypeGone => 'نوع العينة هذا لم يعد موجودًا. حدّث القائمة.';
  @override
  String get navSampleTypes => 'أنواع العينات';
  @override
  String get sampleTypesTitle => 'أنواع العينات';
  @override
  String get sampleTypesSubtitle => 'دليل أنواع العينات في معاملك.';
  @override
  String get sampleTypeNameLabel => 'نوع العينة';
  @override
  String get sampleTypeDescriptionLabel => 'الوصف';
  @override
  String get searchSampleTypesHint => 'ابحث باسم نوع العينة';
  @override
  String get sampleTypesEmptyTitle => 'لا توجد أنواع عينات بعد';
  @override
  String get sampleTypesEmptyMessage =>
      'أنواع العينات التي تضيفها إلى فرع ستظهر هنا.';
  @override
  String get sampleTypesNoMatchTitle => 'لا توجد أنواع عينات مطابقة';
  @override
  String get sampleTypesNoMatchMessage => 'جرّب بحثًا أو تصفية مختلفة.';
  @override
  String get feedbackSampleTypesTitle => 'تعذّر تحميل أنواع العينات';
  @override
  String get navParameters => 'البارامترات';
  @override
  String get parametersTitle => 'البارامترات';
  @override
  String get parametersSubtitle => 'العناصر التي تقيسها تحاليلك في معاملك.';
  @override
  String get newParameter => 'بارامتر جديد';
  @override
  String get createParameterTitle => 'بارامتر جديد';
  @override
  String get createParameterSubtitle => 'أضف بارامترًا إلى فرع في أحد معاملك.';
  @override
  String get editParameterTitle => 'تعديل البارامتر';
  @override
  String get editParameterSubtitle => 'عدّل بيانات البارامتر ومكانه.';
  @override
  String get parameterNameLabel => 'البارامتر';
  @override
  String get parameterNameRequired => 'أدخل اسم البارامتر.';
  @override
  String get parameterNameTooLong => 'اجعل الاسم أقل من 150 حرفًا.';
  @override
  String get parameterDescriptionLabel => 'الوصف';
  @override
  String get parameterDescriptionTooLong => 'اجعل الوصف أقل من 500 حرف.';
  @override
  String get parameterBranchLabel => 'الفرع';
  @override
  String get parameterBranchRequired => 'اختر الفرع.';
  @override
  String get parameterBranchEmpty =>
      'لا يوجد فرع نشط في هذا المعمل. فعّل فرعًا أولًا.';
  @override
  String get creatingParameter => 'جارٍ الإنشاء…';
  @override
  String get feedbackSaveParameterTitle => 'تعذّر حفظ البارامتر';
  @override
  String get parameterCreatedTitle => 'تم إنشاء البارامتر';
  @override
  String get parameterCreatedMessage => 'أصبح ظاهرًا في القائمة بالأسفل.';
  @override
  String get parameterSavedTitle => 'تم حفظ البارامتر';
  @override
  String get parameterSavedMessage => 'تم تطبيق تعديلاتك.';
  @override
  String get parameterDetailsTitle => 'بيانات البارامتر';
  @override
  String get parameterDetailsSubtitle => 'كل ما تعرفه المنصة عن هذا البارامتر.';
  @override
  String get backToParameters => 'العودة إلى البارامترات';
  @override
  String get feedbackParameterDetailsTitle => 'تعذّر تحميل بيانات البارامتر';
  @override
  String get feedbackDeleteParameterTitle => 'تعذّر حذف البارامتر';
  @override
  String get deleteParameterTitle => 'حذف البارامتر';
  @override
  String deleteParameterPrompt(String name) => 'حذف $name؟';
  @override
  String get deleteParameterHint =>
      'ينتقل إلى سلة المحذوفات، ويمكن لمسؤول استعادته.';
  @override
  String get deletingParameter => 'جارٍ الحذف…';
  @override
  String get parameterDeletedTitle => 'تم حذف البارامتر';
  @override
  String get parameterDeletedMessage => 'تم نقله إلى سلة المحذوفات.';
  @override
  String get parameterActivatedTitle => 'تم تفعيل البارامتر';
  @override
  String get parameterActivatedMessage => 'أصبح متاحًا للاستخدام من جديد.';
  @override
  String get parameterDeactivatedTitle => 'تم إيقاف البارامتر';
  @override
  String get parameterDeactivatedMessage =>
      'يظل ظاهرًا في القائمة لكنه مغلق للاستخدام.';
  @override
  String get feedbackParameterStatusTitle => 'تعذّر تغيير حالة البارامتر';
  @override
  String get parameterGone => 'هذا البارامتر لم يعد موجودًا. حدّث القائمة.';
  @override
  String get searchParametersHint => 'ابحث باسم البارامتر';
  @override
  String get parametersEmptyTitle => 'لا توجد بارامترات بعد';
  @override
  String get parametersEmptyMessage =>
      'البارامترات التي تضيفها إلى فرع ستظهر هنا.';
  @override
  String get parametersNoMatchTitle => 'لا توجد بارامترات مطابقة';
  @override
  String get parametersNoMatchMessage => 'جرّب بحثًا أو تصفية مختلفة.';
  @override
  String get feedbackParametersTitle => 'تعذّر تحميل البارامترات';
  @override
  String get newUnit => 'وحدة جديدة';
  @override
  String get createUnitTitle => 'وحدة جديدة';
  @override
  String get createUnitSubtitle => 'أضف وحدة إلى فرع في أحد معاملك.';
  @override
  String get editUnitTitle => 'تعديل الوحدة';
  @override
  String get editUnitSubtitle => 'عدّل بيانات الوحدة ومكانها.';
  @override
  String get unitNameRequired => 'أدخل اسم الوحدة.';
  @override
  String get unitNameTooLong => 'اجعل الاسم أقل من 150 حرفًا.';
  @override
  String get unitSymbolRequired => 'أدخل رمز الوحدة.';
  @override
  String get unitSymbolTooLong => 'اجعل الرمز أقل من 50 حرفًا.';
  @override
  String get unitDescriptionTooLong => 'اجعل الوصف أقل من 500 حرف.';
  @override
  String get unitBranchLabel => 'الفرع';
  @override
  String get unitBranchRequired => 'اختر الفرع.';
  @override
  String get unitBranchEmpty =>
      'لا يوجد فرع نشط في هذا المعمل. فعّل فرعًا أولًا.';
  @override
  String get creatingUnit => 'جارٍ الإنشاء…';
  @override
  String get feedbackSaveUnitTitle => 'تعذّر حفظ الوحدة';
  @override
  String get unitCreatedTitle => 'تم إنشاء الوحدة';
  @override
  String get unitCreatedMessage => 'أصبحت ظاهرة في القائمة بالأسفل.';
  @override
  String get unitSavedTitle => 'تم حفظ الوحدة';
  @override
  String get unitSavedMessage => 'تم تطبيق تعديلاتك.';
  @override
  String get unitDetailsTitle => 'بيانات الوحدة';
  @override
  String get unitDetailsSubtitle => 'كل ما تعرفه المنصة عن هذه الوحدة.';
  @override
  String get backToUnits => 'العودة إلى الوحدات';
  @override
  String get feedbackUnitDetailsTitle => 'تعذّر تحميل بيانات الوحدة';
  @override
  String get feedbackDeleteUnitTitle => 'تعذّر حذف الوحدة';
  @override
  String get deleteUnitTitle => 'حذف الوحدة';
  @override
  String deleteUnitPrompt(String name) => 'حذف $name؟';
  @override
  String get deleteUnitHint =>
      'تنتقل إلى سلة المحذوفات، ويمكن لمسؤول استعادتها.';
  @override
  String get deletingUnit => 'جارٍ الحذف…';
  @override
  String get unitDeletedTitle => 'تم حذف الوحدة';
  @override
  String get unitDeletedMessage => 'تم نقلها إلى سلة المحذوفات.';
  @override
  String get unitActivatedTitle => 'تم تفعيل الوحدة';
  @override
  String get unitActivatedMessage => 'أصبحت متاحة للاستخدام من جديد.';
  @override
  String get unitDeactivatedTitle => 'تم إيقاف الوحدة';
  @override
  String get unitDeactivatedMessage =>
      'تظل ظاهرة في القائمة لكنها مغلقة للاستخدام.';
  @override
  String get feedbackUnitStatusTitle => 'تعذّر تغيير حالة الوحدة';
  @override
  String get unitGone => 'هذه الوحدة لم تعد موجودة. حدّث القائمة.';
  @override
  String get navUnits => 'الوحدات';
  @override
  String get unitsTitle => 'الوحدات';
  @override
  String get unitsSubtitle => 'دليل وحدات القياس في معاملك.';
  @override
  String get unitNameLabel => 'الوحدة';
  @override
  String get unitSymbolLabel => 'الرمز';
  @override
  String get unitDescriptionLabel => 'الوصف';
  @override
  String get searchUnitsHint => 'ابحث باسم الوحدة';
  @override
  String get unitsEmptyTitle => 'لا توجد وحدات بعد';
  @override
  String get unitsEmptyMessage => 'الوحدات التي تضيفها إلى فرع ستظهر هنا.';
  @override
  String get unitsNoMatchTitle => 'لا توجد وحدات مطابقة';
  @override
  String get unitsNoMatchMessage => 'جرّب بحثًا أو تصفية مختلفة.';
  @override
  String get feedbackUnitsTitle => 'تعذّر تحميل الوحدات';
  @override
  String get navUsers => 'المستخدمون';
  @override
  String get usersTitle => 'المستخدمون';
  @override
  String get usersSubtitle => 'كل من لديه وصول إلى المنصة.';
  @override
  String get newUser => 'مستخدم جديد';
  @override
  String get createUserTitle => 'مستخدم جديد';
  @override
  String get createUserSubtitle => 'أنشئ حسابًا وحدّد ما يصل إليه.';
  @override
  String get editUserTitle => 'تعديل المستخدم';
  @override
  String get editUserSubtitle => 'عدّل بيانات الحساب وصلاحيات وصوله.';
  @override
  String get userAccountSection => 'الحساب';
  @override
  String get userAccessSection => 'الوصول';
  @override
  String get userNameLabel => 'الاسم الكامل';
  @override
  String get userNameRequired => 'أدخل الاسم الكامل.';
  @override
  String get userNameTooLong => 'اجعل الاسم أقل من 30 حرفًا.';
  @override
  String get userEmailLabel => 'البريد الإلكتروني';
  @override
  String get userEmailTooLong => 'اجعل البريد أقل من 100 حرف.';
  @override
  String get userPasswordLabel => 'كلمة المرور';
  @override
  String get userNewPasswordLabel => 'كلمة مرور جديدة';
  @override
  String get userPasswordKeepHint =>
      'اتركها فارغة للإبقاء على كلمة المرور الحالية.';
  @override
  String get userPasswordTooShort => 'استخدم 8 أحرف على الأقل.';
  @override
  String get userRolesLabel => 'الأدوار';
  @override
  String get userRolesHint => 'الدور يحدد مكان الحساب وما يصل إليه.';
  @override
  String get userRolesUnavailable => 'لا يمكنك إسناد أي دور.';
  @override
  String get userBranchLabel => 'الفرع';
  @override
  String get userBranchEmpty =>
      'لا يوجد فرع نشط في هذا المعمل. فعّل فرعًا أولًا.';
  @override
  String get userCommissionLabel => 'نسبة العمولة %';
  @override
  String get userCommissionRequired => 'النسبة مطلوبة لحسابات فريق العمل.';
  @override
  String get userCommissionRange => 'أدخل رقمًا بين 1 و 100.';
  @override
  String get userPermissionsLabel => 'الصلاحيات';
  @override
  String get userNoPermissions => 'لا توجد صلاحيات';
  @override
  String userPermissionsCount(int count) => '$count صلاحية';
  @override
  String get userNoPhones => 'لا توجد أرقام بعد.';
  @override
  String get userVerified => 'مُفعّل';
  @override
  String get userUnverified => 'غير مُفعّل';
  @override
  String get allRoles => 'كل الأدوار';
  @override
  String roleLabel(String name) => switch (name) {
    'super-admin' => 'مدير عام',
    'team-member' => 'عضو فريق',
    'laboratory-admin' => 'مدير معمل',
    'branch-manager' => 'مدير فرع',
    'doctor' => 'طبيب',
    'receptionist' => 'موظف استقبال',
    _ => name,
  };
  @override
  String get creatingUser => 'جارٍ الإنشاء…';
  @override
  String get feedbackSaveUserTitle => 'تعذّر حفظ المستخدم';
  @override
  String get userCreatedTitle => 'تم إنشاء المستخدم';
  @override
  String get userCreatedMessage => 'الحساب جاهز لتسجيل الدخول.';
  @override
  String get userSavedTitle => 'تم حفظ المستخدم';
  @override
  String get userSavedMessage => 'تم تطبيق تعديلاتك.';
  @override
  String get userDetailsTitle => 'بيانات المستخدم';
  @override
  String get userDetailsSubtitle => 'كل ما تعرفه المنصة عن هذا الحساب.';
  @override
  String get backToUsers => 'العودة إلى المستخدمين';
  @override
  String get feedbackUserDetailsTitle => 'تعذّر تحميل بيانات المستخدم';
  @override
  String get feedbackDeleteUserTitle => 'تعذّر حذف المستخدم';
  @override
  String get deleteUserTitle => 'حذف المستخدم';
  @override
  String deleteUserPrompt(String name) => 'حذف $name؟';
  @override
  String get deleteUserHint =>
      'ينتقل إلى سلة المحذوفات، ويمكن لمسؤول استعادته.';
  @override
  String get deletingUser => 'جارٍ الحذف…';
  @override
  String get userDeletedTitle => 'تم حذف المستخدم';
  @override
  String get userDeletedMessage => 'تم نقله إلى سلة المحذوفات.';
  @override
  String get userGone => 'هذا المستخدم لم يعد موجودًا. حدّث القائمة.';
  @override
  String get searchUsersHint => 'ابحث بالاسم أو البريد';
  @override
  String get usersEmptyTitle => 'لا يوجد مستخدمون بعد';
  @override
  String get usersEmptyMessage => 'الحسابات التي تنشئها ستظهر هنا.';
  @override
  String get usersNoMatchTitle => 'لا يوجد مستخدمون مطابقون';
  @override
  String get usersNoMatchMessage => 'جرّب بحثًا أو تصفية مختلفة.';
  @override
  String get feedbackUsersTitle => 'تعذّر تحميل المستخدمين';
  @override
  String userPermissionsSelected(int count) => 'مختار $count';
  @override
  String get userPermissionsHint =>
      'صلاحيات إضافية فوق الدور، ولا يمكنك منح إلا ما تملكه أنت.';
  @override
  String get userPermissionsUnavailable => 'لا تملك صلاحيات لتمنحها.';
  @override
  String get searchPermissionsHint => 'ابحث في الصلاحيات';
  @override
  String get permissionsNoMatch => 'لا توجد صلاحية مطابقة لهذا البحث.';
  @override
  String get selectAll => 'تحديد الكل';
  @override
  String get deselectAll => 'إلغاء الكل';
  @override
  String get clearSelection => 'مسح';
  @override
  String get loadingPermissions => 'جارٍ تحميل الصلاحيات…';
  @override
  String get feedbackPermissionsTitle => 'تعذّر تحميل الصلاحيات';
  @override
  String get feedbackPermissionsMessage =>
      'يمكن حفظ الحساب بدون صلاحيات إضافية.';
  @override
  String get noDescription => 'بدون وصف';
  @override
  String get navBranches => 'الفروع';
  @override
  String get branchesTitle => 'الفروع';
  @override
  String get branchesSubtitle => 'كل فروع معاملك وبيانات التواصل الخاصة بها.';
  @override
  String get branchNameLabel => 'اسم الفرع';
  @override
  String get branchNameHint => 'فرع وسط البلد';
  @override
  String get branchNameRequired => 'أدخل اسم الفرع.';
  @override
  String get branchNameTooLong => 'اجعل الاسم أقل من 150 حرفًا.';
  @override
  String get branchAddressLabel => 'العنوان';
  @override
  String get branchAddressHint => 'الشارع، المدينة';
  @override
  String get branchAddressTooLong => 'اجعل العنوان أقل من 500 حرف.';
  @override
  String get branchLaboratoryLabel => 'المعمل';
  @override
  String get branchLaboratoryRequired => 'اختر المعمل.';
  @override
  String get branchManagerLabel => 'المسؤول';
  @override
  String get branchPhonesLabel => 'أرقام الهاتف';
  @override
  String get phonesEmptyShort => 'لا توجد أرقام';
  @override
  String get branchMainLabel => 'الفرع الرئيسي';
  @override
  String get branchMainHint =>
      'الفرع الرئيسي للمعمل. تعيينه هنا يلغيه عن باقي الفروع.';
  @override
  String get branchMainPill => 'رئيسي';
  @override
  String get nameLanguageLabel => 'لغة الاسم';
  @override
  String get nameLanguageHint => 'اللغة المكتوب بها الاسم والعنوان.';
  @override
  String get notAssigned => 'غير محدد';
  @override
  String get searchBranchesHint => 'ابحث باسم الفرع';
  @override
  String get allLaboratories => 'كل المعامل';
  @override
  String get branchesEmptyTitle => 'لا توجد فروع بعد';
  @override
  String get branchesEmptyMessage => 'الفروع التي تضيفها إلى معمل ستظهر هنا.';
  @override
  String get branchesNoMatchTitle => 'لا توجد فروع مطابقة';
  @override
  String get branchesNoMatchMessage => 'جرّب بحثًا أو تصفية مختلفة.';
  @override
  String get feedbackBranchesTitle => 'تعذّر تحميل الفروع';
  @override
  String get feedbackBranchDetailsTitle => 'تعذّر تحميل بيانات الفرع';
  @override
  String get feedbackUpdateBranchTitle => 'تعذّر حفظ الفرع';
  @override
  String get feedbackDeleteBranchTitle => 'تعذّر حذف الفرع';
  @override
  String get branchDetailsTitle => 'بيانات الفرع';
  @override
  String get branchDetailsSubtitle => 'كل ما تعرفه المنصة عن هذا الفرع.';
  @override
  String get backToBranches => 'العودة إلى الفروع';
  @override
  String get newBranch => 'فرع جديد';
  @override
  String get createBranchTitle => 'فرع جديد';
  @override
  String get createBranchSubtitle => 'أضف فرعًا إلى أحد معاملك.';
  @override
  String get creatingBranch => 'جارٍ الإنشاء…';
  @override
  String get branchCreatedTitle => 'تم إنشاء الفرع';
  @override
  String get branchCreatedMessage => 'أصبح ظاهرًا في القائمة بالأسفل.';
  @override
  String get editBranch => 'تعديل الفرع';
  @override
  String get editBranchTitle => 'تعديل الفرع';
  @override
  String get editBranchSubtitle => 'عدّل بيانات الفرع ومعمله ووسائل التواصل.';
  @override
  String get branchUpdatedTitle => 'تم حفظ الفرع';
  @override
  String get branchUpdatedMessage => 'تم تطبيق تعديلاتك.';
  @override
  String get deleteBranchTitle => 'حذف الفرع';
  @override
  String deleteBranchPrompt(String name) => 'حذف $name؟';
  @override
  String get deleteBranchHint =>
      'ينتقل إلى سلة المحذوفات، ويمكن لمسؤول استعادته.';
  @override
  String get deletingBranch => 'جارٍ الحذف…';
  @override
  String get branchDeletedTitle => 'تم حذف الفرع';
  @override
  String get branchDeletedMessage => 'تم نقله إلى سلة المحذوفات.';
  @override
  String get branchActivatedTitle => 'تم تفعيل الفرع';
  @override
  String get branchActivatedMessage => 'أصبح متاحًا للاستخدام من جديد.';
  @override
  String get branchDeactivatedTitle => 'تم إيقاف الفرع';
  @override
  String get branchDeactivatedMessage =>
      'يظل ظاهرًا في القائمة لكنه مغلق للاستخدام.';
  @override
  String get feedbackBranchStatusTitle => 'تعذّر تغيير حالة الفرع';
  @override
  String get branchGone => 'هذا الفرع لم يعد موجودًا. حدّث القائمة.';
  @override
  String branchPhonesCount(int count) =>
      count == 1 ? 'رقم واحد' : '$count أرقام';

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
  String get editLaboratorySubtitle =>
      'غيّر الاسم أو الشعار. يُحفظ الاسم باللغة التي تختارها.';
  @override
  String get feedbackUpdateLaboratoryTitle => 'تعذّر تحديث المعمل';
  @override
  String get laboratoryUpdatedTitle => 'تم تحديث المعمل';
  @override
  String get laboratoryUpdatedMessage => 'تم حفظ البيانات الجديدة.';
  @override
  String get laboratoryLogoLabel => 'الشعار';
  @override
  String get laboratoryLogoHint => 'اختياري. يظهر أينما يُعرض هذا المعمل.';
  @override
  String get chooseLogo => 'اختيار شعار';
  @override
  String get changeLogo => 'تغيير الشعار';
  @override
  String get clearLogo => 'إزالة الشعار';
  @override
  String get logoTooLarge => 'اختر صورة PNG أو JPG أقل من 2 ميجابايت.';
  @override
  String get logoHint => 'PNG أو JPG، بحد أقصى 2 ميجابايت.';
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
