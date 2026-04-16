import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'package:artisan_hr/l10n/generated/app_localizations_en.dart';
import 'package:artisan_hr/l10n/generated/app_localizations_id.dart';

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

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTab;

  /// No description provided for @employeeAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee Attendance'**
  String get employeeAttendanceTitle;

  /// No description provided for @loginDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your employee account to access attendance summary, check-in, check-out, and history.'**
  String get loginDescription;

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

  /// No description provided for @employeeFallback.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employeeFallback;

  /// No description provided for @attendanceDashboard.
  ///
  /// In en, this message translates to:
  /// **'Attendance dashboard'**
  String get attendanceDashboard;

  /// No description provided for @employeeNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee No: {value}'**
  String employeeNoLabel(Object value);

  /// No description provided for @todaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today Summary'**
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
  /// **'Your check-in is recorded. You only need to check out later.'**
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
  /// **'Check In'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

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

  /// No description provided for @checkInRange.
  ///
  /// In en, this message translates to:
  /// **'Check-in: {start} - {end}'**
  String checkInRange(Object start, Object end);

  /// No description provided for @checkOutRange.
  ///
  /// In en, this message translates to:
  /// **'Check-out: {start} - {end}'**
  String checkOutRange(Object start, Object end);

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
  /// **'Recent Activity'**
  String get recentActivity;

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
  /// **'Confirm Check In'**
  String get confirmCheckIn;

  /// No description provided for @confirmCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Confirm Check Out'**
  String get confirmCheckOut;

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
