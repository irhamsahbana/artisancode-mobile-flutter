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

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @indonesianLabel.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesianLabel;

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;

  /// No description provided for @refreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshTooltip;

  /// No description provided for @signOutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutTooltip;

  /// No description provided for @moreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActions;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeTab;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTab;

  /// No description provided for @employeeAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s attendance'**
  String get employeeAttendanceTitle;

  /// No description provided for @loginDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your employee account to access attendance summary, check-in, check-out, and history.'**
  String get loginDescription;

  /// No description provided for @onboardingBadge.
  ///
  /// In en, this message translates to:
  /// **'Attendance, made clear'**
  String get onboardingBadge;

  /// No description provided for @onboardingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Clearer check-ins. Smoother workdays.'**
  String get onboardingHeadline;

  /// No description provided for @onboardingSubheadline.
  ///
  /// In en, this message translates to:
  /// **'Presense helps you review today\'s status, record attendance with the right proof, and revisit history without extra friction.'**
  String get onboardingSubheadline;

  /// No description provided for @onboardingAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'See today\'s status at a glance'**
  String get onboardingAttendanceTitle;

  /// No description provided for @onboardingAttendanceDescription.
  ///
  /// In en, this message translates to:
  /// **'As soon as you sign in, you can view your attendance summary, check-in or check-out status, and today\'s active shift.'**
  String get onboardingAttendanceDescription;

  /// No description provided for @onboardingProofTitle.
  ///
  /// In en, this message translates to:
  /// **'Record attendance with clear proof'**
  String get onboardingProofTitle;

  /// No description provided for @onboardingProofDescription.
  ///
  /// In en, this message translates to:
  /// **'The check-in and check-out flow is ready to submit live location, notes, and photo proof in line with company policy.'**
  String get onboardingProofDescription;

  /// No description provided for @justInTimePermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera and location appear only when they matter'**
  String get justInTimePermissionsTitle;

  /// No description provided for @justInTimePermissionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Device permission is requested right before you capture selfie proof or attach coordinates, so the flow stays transparent and easy to trust.'**
  String get justInTimePermissionsDescription;

  /// No description provided for @onboardingHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'History stays easy to scan'**
  String get onboardingHistoryTitle;

  /// No description provided for @onboardingHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Review clock-in time, clock-out time, late arrivals, and early departures in one tidy summary.'**
  String get onboardingHistoryDescription;

  /// No description provided for @onboardingPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Device access consent'**
  String get onboardingPermissionsTitle;

  /// No description provided for @onboardingPermissionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Before using attendance features, we want to make sure you understand why the app needs location and camera access.'**
  String get onboardingPermissionsDescription;

  /// No description provided for @onboardingLocationConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow location access'**
  String get onboardingLocationConsentTitle;

  /// No description provided for @onboardingLocationConsentDescription.
  ///
  /// In en, this message translates to:
  /// **'Location is used to attach coordinates during check-in and check-out so attendance can be verified according to work policy.'**
  String get onboardingLocationConsentDescription;

  /// No description provided for @onboardingCameraConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access'**
  String get onboardingCameraConsentTitle;

  /// No description provided for @onboardingCameraConsentDescription.
  ///
  /// In en, this message translates to:
  /// **'Camera access is used to capture photo proof on every check-in and check-out so attendance records stay accurate.'**
  String get onboardingCameraConsentDescription;

  /// No description provided for @onboardingPermissionHint.
  ///
  /// In en, this message translates to:
  /// **'After you agree here, your device may still ask for the official system permission the first time each feature is used.'**
  String get onboardingPermissionHint;

  /// No description provided for @onboardingConsentRequired.
  ///
  /// In en, this message translates to:
  /// **'Agree to location and camera access before continuing to login.'**
  String get onboardingConsentRequired;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Sign in with my account'**
  String get onboardingGetStarted;

  /// No description provided for @skipIntro.
  ///
  /// In en, this message translates to:
  /// **'Skip intro'**
  String get skipIntro;

  /// No description provided for @backToOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Back to intro'**
  String get backToOnboarding;

  /// No description provided for @loginCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Presense'**
  String get loginCardTitle;

  /// No description provided for @loginCardDescription.
  ///
  /// In en, this message translates to:
  /// **'Use your employee account to review today\'s status, record attendance, and open history quickly.'**
  String get loginCardDescription;

  /// No description provided for @permissionUsageSummary.
  ///
  /// In en, this message translates to:
  /// **'Camera and location are requested only during check-in or check-out, not on the sign-in screen.'**
  String get permissionUsageSummary;

  /// No description provided for @showAdvancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Show advanced settings'**
  String get showAdvancedSettings;

  /// No description provided for @apiBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'API Base URL'**
  String get apiBaseUrl;

  /// No description provided for @apiBaseUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'API base URL is required.'**
  String get apiBaseUrlRequired;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get emailRequired;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get passwordRequired;

  /// No description provided for @tenantCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Tenant Code'**
  String get tenantCodeLabel;

  /// No description provided for @tenantCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Tenant code is required.'**
  String get tenantCodeRequired;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @unableToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign in.'**
  String get unableToSignIn;

  /// No description provided for @apiUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: You can override the API URL here for emulator, simulator, or local device testing.'**
  String get apiUrlHint;

  /// No description provided for @signedInSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully.'**
  String get signedInSuccessfully;

  /// No description provided for @signedOut.
  ///
  /// In en, this message translates to:
  /// **'Signed out.'**
  String get signedOut;

  /// No description provided for @checkInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-in recorded successfully with photo proof.'**
  String get checkInSuccess;

  /// No description provided for @checkOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-out recorded successfully with photo proof.'**
  String get checkOutSuccess;

  /// No description provided for @syncingAttendanceData.
  ///
  /// In en, this message translates to:
  /// **'Syncing attendance data...'**
  String get syncingAttendanceData;

  /// No description provided for @employeeFallback.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employeeFallback;

  /// No description provided for @attendanceDashboard.
  ///
  /// In en, this message translates to:
  /// **'Attendance overview'**
  String get attendanceDashboard;

  /// No description provided for @employeeNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee No: {value}'**
  String employeeNoLabel(Object value);

  /// No description provided for @todaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s summary'**
  String get todaySummary;

  /// No description provided for @noSummary.
  ///
  /// In en, this message translates to:
  /// **'No summary data is available yet.'**
  String get noSummary;

  /// No description provided for @todayStatus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Status'**
  String get todayStatus;

  /// No description provided for @todayStatusNotCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Not checked in yet'**
  String get todayStatusNotCheckedIn;

  /// No description provided for @todayStatusCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get todayStatusCheckedIn;

  /// No description provided for @todayStatusCheckedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked out'**
  String get todayStatusCheckedOut;

  /// No description provided for @todayStatusNotCheckedInDescription.
  ///
  /// In en, this message translates to:
  /// **'You have not recorded attendance yet today.'**
  String get todayStatusNotCheckedInDescription;

  /// No description provided for @todayStatusCheckedInDescription.
  ///
  /// In en, this message translates to:
  /// **'Your check-in is recorded. Check out when your workday is complete.'**
  String get todayStatusCheckedInDescription;

  /// No description provided for @todayStatusCheckedOutDescription.
  ///
  /// In en, this message translates to:
  /// **'Your attendance is complete for today.'**
  String get todayStatusCheckedOutDescription;

  /// No description provided for @attendanceDate.
  ///
  /// In en, this message translates to:
  /// **'Attendance Date'**
  String get attendanceDate;

  /// No description provided for @checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked In'**
  String get checkedIn;

  /// No description provided for @checkedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked Out'**
  String get checkedOut;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @noLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// No description provided for @noAttendanceActivity.
  ///
  /// In en, this message translates to:
  /// **'No attendance activity recorded yet today.'**
  String get noAttendanceActivity;

  /// No description provided for @lastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last activity: {type} at {loggedAt}'**
  String lastActivity(Object type, Object loggedAt);

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @loadingAttendanceState.
  ///
  /// In en, this message translates to:
  /// **'Checking your attendance status.'**
  String get loadingAttendanceState;

  /// No description provided for @checkInAlreadyRecorded.
  ///
  /// In en, this message translates to:
  /// **'Check-in is already recorded for today.'**
  String get checkInAlreadyRecorded;

  /// No description provided for @checkInUnavailableHint.
  ///
  /// In en, this message translates to:
  /// **'Check-in is not available yet. Review today\'s status or refresh again in a moment.'**
  String get checkInUnavailableHint;

  /// No description provided for @checkOutRequiresCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-out becomes available after you check in.'**
  String get checkOutRequiresCheckIn;

  /// No description provided for @checkOutAlreadyRecorded.
  ///
  /// In en, this message translates to:
  /// **'Check-out is already recorded for today.'**
  String get checkOutAlreadyRecorded;

  /// No description provided for @checkOutUnavailableHint.
  ///
  /// In en, this message translates to:
  /// **'Check-out is not available yet. Review your shift and attendance status first.'**
  String get checkOutUnavailableHint;

  /// No description provided for @shiftToday.
  ///
  /// In en, this message translates to:
  /// **'Shift Today'**
  String get shiftToday;

  /// No description provided for @noShiftScheduled.
  ///
  /// In en, this message translates to:
  /// **'No shift scheduled today.'**
  String get noShiftScheduled;

  /// No description provided for @unnamedShift.
  ///
  /// In en, this message translates to:
  /// **'Unnamed shift'**
  String get unnamedShift;

  /// No description provided for @startLabel.
  ///
  /// In en, this message translates to:
  /// **'Start: {value}'**
  String startLabel(Object value);

  /// No description provided for @endLabel.
  ///
  /// In en, this message translates to:
  /// **'End: {value}'**
  String endLabel(Object value);

  /// No description provided for @attendancePolicy.
  ///
  /// In en, this message translates to:
  /// **'Attendance Policy'**
  String get attendancePolicy;

  /// No description provided for @noPolicy.
  ///
  /// In en, this message translates to:
  /// **'No policy data available.'**
  String get noPolicy;

  /// No description provided for @timezoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Timezone: {value}'**
  String timezoneLabel(Object value);

  /// No description provided for @attendanceRadiusLabel.
  ///
  /// In en, this message translates to:
  /// **'Attendance radius: {value} m'**
  String attendanceRadiusLabel(Object value);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @employeeProfileMissing.
  ///
  /// In en, this message translates to:
  /// **'Employee profile not found for this user.'**
  String get employeeProfileMissing;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name: {value}'**
  String nameLabel(Object value);

  /// No description provided for @emailValue.
  ///
  /// In en, this message translates to:
  /// **'Email: {value}'**
  String emailValue(Object value);

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: {value}'**
  String statusLabel(Object value);

  /// No description provided for @photoProofRequired.
  ///
  /// In en, this message translates to:
  /// **'Photo proof: required on every check-in and check-out'**
  String get photoProofRequired;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @viewAllHistory.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAllHistory;

  /// No description provided for @noRecentLogs.
  ///
  /// In en, this message translates to:
  /// **'No recent logs'**
  String get noRecentLogs;

  /// No description provided for @noRecentLogsDescription.
  ///
  /// In en, this message translates to:
  /// **'Your latest attendance actions will show up here.'**
  String get noRecentLogsDescription;

  /// No description provided for @confirmCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Confirm check-in'**
  String get confirmCheckIn;

  /// No description provided for @confirmCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Confirm check-out'**
  String get confirmCheckOut;

  /// No description provided for @checkInSheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete the final details, capture selfie proof, and submit your check-in in one flow.'**
  String get checkInSheetDescription;

  /// No description provided for @checkOutSheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Capture selfie proof and submit check-out when your workday is complete.'**
  String get checkOutSheetDescription;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @deviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get deviceNameLabel;

  /// No description provided for @selfieProofTitle.
  ///
  /// In en, this message translates to:
  /// **'Selfie proof'**
  String get selfieProofTitle;

  /// No description provided for @selfieAttached.
  ///
  /// In en, this message translates to:
  /// **'Selfie proof is ready to submit.'**
  String get selfieAttached;

  /// No description provided for @selfieRequiredHint.
  ///
  /// In en, this message translates to:
  /// **'Capture a selfie before you submit attendance.'**
  String get selfieRequiredHint;

  /// No description provided for @captureSelfie.
  ///
  /// In en, this message translates to:
  /// **'Capture selfie'**
  String get captureSelfie;

  /// No description provided for @retakeSelfie.
  ///
  /// In en, this message translates to:
  /// **'Retake selfie'**
  String get retakeSelfie;

  /// No description provided for @removeSelfie.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeSelfie;

  /// No description provided for @submittingAttendance.
  ///
  /// In en, this message translates to:
  /// **'Submitting attendance...'**
  String get submittingAttendance;

  /// No description provided for @submitCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Submit check-in'**
  String get submitCheckIn;

  /// No description provided for @submitCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Submit check-out'**
  String get submitCheckOut;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @unableToLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Unable to load history'**
  String get unableToLoadHistory;

  /// No description provided for @historyLoadErrorHint.
  ///
  /// In en, this message translates to:
  /// **'Refresh again to load your attendance history.'**
  String get historyLoadErrorHint;

  /// No description provided for @noAttendanceLogsYet.
  ///
  /// In en, this message translates to:
  /// **'No attendance logs yet'**
  String get noAttendanceLogsYet;

  /// No description provided for @noAttendanceLogsDescription.
  ///
  /// In en, this message translates to:
  /// **'Your attendance history will appear here after you check in or check out.'**
  String get noAttendanceLogsDescription;

  /// No description provided for @noRecord.
  ///
  /// In en, this message translates to:
  /// **'No record'**
  String get noRecord;

  /// No description provided for @lateClockIn.
  ///
  /// In en, this message translates to:
  /// **'Late clock in'**
  String get lateClockIn;

  /// No description provided for @earlyClockOut.
  ///
  /// In en, this message translates to:
  /// **'Early clock out'**
  String get earlyClockOut;

  /// No description provided for @noClockIn.
  ///
  /// In en, this message translates to:
  /// **'No clock in'**
  String get noClockIn;

  /// No description provided for @noClockOut.
  ///
  /// In en, this message translates to:
  /// **'No clock out'**
  String get noClockOut;

  /// No description provided for @weekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get weekend;

  /// No description provided for @workShift.
  ///
  /// In en, this message translates to:
  /// **'Work shift'**
  String get workShift;

  /// No description provided for @noAttendanceRecord.
  ///
  /// In en, this message translates to:
  /// **'No attendance record'**
  String get noAttendanceRecord;

  /// No description provided for @statusToneLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparing today\'s status'**
  String get statusToneLoadingTitle;

  /// No description provided for @statusToneLoadingDescription.
  ///
  /// In en, this message translates to:
  /// **'One moment. We are checking your latest attendance data.'**
  String get statusToneLoadingDescription;

  /// No description provided for @statusToneReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to check in'**
  String get statusToneReadyTitle;

  /// No description provided for @statusToneReadyDescription.
  ///
  /// In en, this message translates to:
  /// **'Review your details, capture selfie proof, and submit attendance.'**
  String get statusToneReadyDescription;

  /// No description provided for @statusToneCheckedInTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in recorded'**
  String get statusToneCheckedInTitle;

  /// No description provided for @statusToneCheckedInDescription.
  ///
  /// In en, this message translates to:
  /// **'Your attendance is active. Remember to check out later.'**
  String get statusToneCheckedInDescription;

  /// No description provided for @statusToneDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'All set for today'**
  String get statusToneDoneTitle;

  /// No description provided for @statusToneDoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Your check-in and check-out are both recorded for today.'**
  String get statusToneDoneDescription;

  /// No description provided for @historySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'History overview'**
  String get historySummaryTitle;

  /// No description provided for @historySummaryDescription.
  ///
  /// In en, this message translates to:
  /// **'Review monthly attendance patterns and open each workday in one tap.'**
  String get historySummaryDescription;
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
