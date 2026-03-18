import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Insurance Customer Portal'**
  String get appTitle;

  /// Welcome message on splash screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to My Customer'**
  String get welcomeToMyCustomer;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmail;

  /// No description provided for @requestOtp.
  ///
  /// In en, this message translates to:
  /// **'Request OTP'**
  String get requestOtp;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordRequest.
  ///
  /// In en, this message translates to:
  /// **'Reset Password Request'**
  String get resetPasswordRequest;

  /// No description provided for @resetPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'Reset password request has been sent to your email'**
  String get resetPasswordSent;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get invalidOtp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @invalidUsernameOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get invalidUsernameOrPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @portfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolio;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @totalPolicies.
  ///
  /// In en, this message translates to:
  /// **'Total Policies'**
  String get totalPolicies;

  /// No description provided for @totalPremium.
  ///
  /// In en, this message translates to:
  /// **'Total Premium'**
  String get totalPremium;

  /// No description provided for @totalBenefits.
  ///
  /// In en, this message translates to:
  /// **'Total Benefits'**
  String get totalBenefits;

  /// No description provided for @policyTracker.
  ///
  /// In en, this message translates to:
  /// **'Policy Tracker'**
  String get policyTracker;

  /// No description provided for @submitProposal.
  ///
  /// In en, this message translates to:
  /// **'Submit Proposal'**
  String get submitProposal;

  /// No description provided for @submitClaim.
  ///
  /// In en, this message translates to:
  /// **'Submit Claim'**
  String get submitClaim;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedForYou;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @myPolicies.
  ///
  /// In en, this message translates to:
  /// **'My Policies'**
  String get myPolicies;

  /// No description provided for @policyDetails.
  ///
  /// In en, this message translates to:
  /// **'Policy Details'**
  String get policyDetails;

  /// No description provided for @activePolicies.
  ///
  /// In en, this message translates to:
  /// **'Active Policies'**
  String get activePolicies;

  /// No description provided for @lapsedPolicies.
  ///
  /// In en, this message translates to:
  /// **'Lapsed Policies'**
  String get lapsedPolicies;

  /// No description provided for @pendingPolicies.
  ///
  /// In en, this message translates to:
  /// **'Pending Policies'**
  String get pendingPolicies;

  /// No description provided for @claims.
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get claims;

  /// No description provided for @claimDetails.
  ///
  /// In en, this message translates to:
  /// **'Claim Details'**
  String get claimDetails;

  /// No description provided for @claimTracker.
  ///
  /// In en, this message translates to:
  /// **'Claim Tracker'**
  String get claimTracker;

  /// No description provided for @illustrations.
  ///
  /// In en, this message translates to:
  /// **'Illustrations'**
  String get illustrations;

  /// No description provided for @createIllustration.
  ///
  /// In en, this message translates to:
  /// **'Create Illustration'**
  String get createIllustration;

  /// No description provided for @proposals.
  ///
  /// In en, this message translates to:
  /// **'Proposals'**
  String get proposals;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email Address'**
  String get invalidEmail;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get invalidPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network Error. Please check your connection.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server Error. Please try again later.'**
  String get serverError;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session Expired. Please login again.'**
  String get sessionExpired;

  /// No description provided for @policyNumber.
  ///
  /// In en, this message translates to:
  /// **'Policy Number'**
  String get policyNumber;

  /// No description provided for @policyStatus.
  ///
  /// In en, this message translates to:
  /// **'Policy Status'**
  String get policyStatus;

  /// No description provided for @policyHolder.
  ///
  /// In en, this message translates to:
  /// **'Policy Holder'**
  String get policyHolder;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @sumAssured.
  ///
  /// In en, this message translates to:
  /// **'Sum Assured'**
  String get sumAssured;

  /// No description provided for @paymentDueDate.
  ///
  /// In en, this message translates to:
  /// **'Payment Due Date'**
  String get paymentDueDate;

  /// No description provided for @claimNumber.
  ///
  /// In en, this message translates to:
  /// **'Claim Number'**
  String get claimNumber;

  /// No description provided for @claimStatus.
  ///
  /// In en, this message translates to:
  /// **'Claim Status'**
  String get claimStatus;

  /// No description provided for @claimAmount.
  ///
  /// In en, this message translates to:
  /// **'Claim Amount'**
  String get claimAmount;

  /// No description provided for @submittedOn.
  ///
  /// In en, this message translates to:
  /// **'Submitted On'**
  String get submittedOn;

  /// No description provided for @approvedOn.
  ///
  /// In en, this message translates to:
  /// **'Approved On'**
  String get approvedOn;

  /// No description provided for @paidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid On'**
  String get paidOn;

  /// No description provided for @statusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get statusSubmitted;

  /// No description provided for @statusInReview.
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get statusInReview;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusLapsed.
  ///
  /// In en, this message translates to:
  /// **'Lapsed'**
  String get statusLapsed;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @contractPeriod.
  ///
  /// In en, this message translates to:
  /// **'Contract Period'**
  String get contractPeriod;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @policyDetail.
  ///
  /// In en, this message translates to:
  /// **'Policy Detail'**
  String get policyDetail;

  /// No description provided for @noPoliciesFound.
  ///
  /// In en, this message translates to:
  /// **'No policies found'**
  String get noPoliciesFound;

  /// No description provided for @coverageAmount.
  ///
  /// In en, this message translates to:
  /// **'Coverage Amount'**
  String get coverageAmount;

  /// No description provided for @premiumAmount.
  ///
  /// In en, this message translates to:
  /// **'Premium Amount'**
  String get premiumAmount;

  /// No description provided for @premiumFrequency.
  ///
  /// In en, this message translates to:
  /// **'Premium Frequency'**
  String get premiumFrequency;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @beneficiary.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary'**
  String get beneficiary;

  /// No description provided for @policyOwner.
  ///
  /// In en, this message translates to:
  /// **'Policy Owner'**
  String get policyOwner;

  /// No description provided for @insuredPerson.
  ///
  /// In en, this message translates to:
  /// **'Insured Person'**
  String get insuredPerson;

  /// No description provided for @issueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue Date'**
  String get issueDate;

  /// No description provided for @maturityDate.
  ///
  /// In en, this message translates to:
  /// **'Maturity Date'**
  String get maturityDate;

  /// Claims Tracker title
  ///
  /// In en, this message translates to:
  /// **'Claims Tracker'**
  String get claimsTracker;

  /// No description provided for @submissionDate.
  ///
  /// In en, this message translates to:
  /// **'Submission Date'**
  String get submissionDate;

  /// No description provided for @claimType.
  ///
  /// In en, this message translates to:
  /// **'Claim Type'**
  String get claimType;

  /// No description provided for @newClaim.
  ///
  /// In en, this message translates to:
  /// **'New Claim'**
  String get newClaim;

  /// No description provided for @claimSubmission.
  ///
  /// In en, this message translates to:
  /// **'Claim Submission'**
  String get claimSubmission;

  /// No description provided for @incidentDate.
  ///
  /// In en, this message translates to:
  /// **'Incident Date'**
  String get incidentDate;

  /// No description provided for @incidentDescription.
  ///
  /// In en, this message translates to:
  /// **'Incident Description'**
  String get incidentDescription;

  /// No description provided for @hospitalName.
  ///
  /// In en, this message translates to:
  /// **'Hospital Name'**
  String get hospitalName;

  /// No description provided for @claimSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Claim Submitted Successfully'**
  String get claimSubmitted;

  /// No description provided for @selectPolicy.
  ///
  /// In en, this message translates to:
  /// **'Select Policy'**
  String get selectPolicy;

  /// No description provided for @death.
  ///
  /// In en, this message translates to:
  /// **'Death'**
  String get death;

  /// No description provided for @criticalIllness.
  ///
  /// In en, this message translates to:
  /// **'Critical Illness'**
  String get criticalIllness;

  /// No description provided for @hospitalization.
  ///
  /// In en, this message translates to:
  /// **'Hospitalization'**
  String get hospitalization;

  /// No description provided for @surgical.
  ///
  /// In en, this message translates to:
  /// **'Surgical'**
  String get surgical;

  /// No description provided for @accident.
  ///
  /// In en, this message translates to:
  /// **'Accident'**
  String get accident;

  /// No description provided for @noClaimsFound.
  ///
  /// In en, this message translates to:
  /// **'No claims found'**
  String get noClaimsFound;

  /// No description provided for @approvedAmount.
  ///
  /// In en, this message translates to:
  /// **'Approved Amount'**
  String get approvedAmount;

  /// No description provided for @processedDate.
  ///
  /// In en, this message translates to:
  /// **'Processed Date'**
  String get processedDate;

  /// No description provided for @incidentDetails.
  ///
  /// In en, this message translates to:
  /// **'Incident Details'**
  String get incidentDetails;

  /// No description provided for @accountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// No description provided for @placeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Place of Birth'**
  String get placeOfBirth;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @homeNumber.
  ///
  /// In en, this message translates to:
  /// **'Home Number'**
  String get homeNumber;

  /// No description provided for @officeNumber.
  ///
  /// In en, this message translates to:
  /// **'Office Number'**
  String get officeNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressType.
  ///
  /// In en, this message translates to:
  /// **'Address Type'**
  String get addressType;

  /// No description provided for @homeAddress.
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get homeAddress;

  /// No description provided for @officeAddress.
  ///
  /// In en, this message translates to:
  /// **'Office Address'**
  String get officeAddress;

  /// No description provided for @correspondenceAddress.
  ///
  /// In en, this message translates to:
  /// **'Correspondence Address'**
  String get correspondenceAddress;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @province.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @subDistrict.
  ///
  /// In en, this message translates to:
  /// **'Sub District'**
  String get subDistrict;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @editContact.
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get editContact;

  /// No description provided for @contactAdded.
  ///
  /// In en, this message translates to:
  /// **'Contact Added Successfully'**
  String get contactAdded;

  /// No description provided for @contactUpdated.
  ///
  /// In en, this message translates to:
  /// **'Contact Updated Successfully'**
  String get contactUpdated;

  /// No description provided for @contactDeleted.
  ///
  /// In en, this message translates to:
  /// **'Contact Deleted Successfully'**
  String get contactDeleted;

  /// No description provided for @deleteContactConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this contact?'**
  String get deleteContactConfirm;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @addressAdded.
  ///
  /// In en, this message translates to:
  /// **'Address Added Successfully'**
  String get addressAdded;

  /// No description provided for @addressUpdated.
  ///
  /// In en, this message translates to:
  /// **'Address Updated Successfully'**
  String get addressUpdated;

  /// No description provided for @addressDeleted.
  ///
  /// In en, this message translates to:
  /// **'Address Deleted Successfully'**
  String get addressDeleted;

  /// No description provided for @deleteAddressConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get deleteAddressConfirm;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated Successfully'**
  String get profileUpdated;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password Changed Successfully'**
  String get passwordChanged;

  /// No description provided for @islam.
  ///
  /// In en, this message translates to:
  /// **'Islam'**
  String get islam;

  /// No description provided for @christian.
  ///
  /// In en, this message translates to:
  /// **'Christian'**
  String get christian;

  /// No description provided for @catholic.
  ///
  /// In en, this message translates to:
  /// **'Catholic'**
  String get catholic;

  /// No description provided for @hindu.
  ///
  /// In en, this message translates to:
  /// **'Hindu'**
  String get hindu;

  /// No description provided for @buddha.
  ///
  /// In en, this message translates to:
  /// **'Buddha'**
  String get buddha;

  /// No description provided for @confucian.
  ///
  /// In en, this message translates to:
  /// **'Confucian'**
  String get confucian;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @productDetail.
  ///
  /// In en, this message translates to:
  /// **'Product Detail'**
  String get productDetail;

  /// No description provided for @productCode.
  ///
  /// In en, this message translates to:
  /// **'Product Code'**
  String get productCode;

  /// No description provided for @productType.
  ///
  /// In en, this message translates to:
  /// **'Product Type'**
  String get productType;

  /// No description provided for @marketingChannel.
  ///
  /// In en, this message translates to:
  /// **'Marketing Channel'**
  String get marketingChannel;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Insurance Customer Portal is your trusted partner for managing insurance policies, tracking claims, and exploring insurance products.'**
  String get appDescription;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @deviceVersion.
  ///
  /// In en, this message translates to:
  /// **'Device Version'**
  String get deviceVersion;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get indonesian;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
