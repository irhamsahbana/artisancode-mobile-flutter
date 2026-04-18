// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageLabel => 'Language';

  @override
  String get indonesianLabel => 'Indonesian';

  @override
  String get englishLabel => 'English';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get signOutTooltip => 'Sign out';

  @override
  String get moreActions => 'More actions';

  @override
  String get homeTab => 'Today';

  @override
  String get historyTab => 'History';

  @override
  String get employeeAttendanceTitle => 'Today\'s attendance';

  @override
  String get loginDescription =>
      'Sign in with your employee account to access attendance summary, check-in, check-out, and history.';

  @override
  String get onboardingBadge => 'Attendance, made clear';

  @override
  String get onboardingHeadline => 'Clearer check-ins. Smoother workdays.';

  @override
  String get onboardingSubheadline =>
      'Presense helps you review today\'s status, record attendance with the right proof, and revisit history without extra friction.';

  @override
  String get onboardingAttendanceTitle => 'See today\'s status at a glance';

  @override
  String get onboardingAttendanceDescription =>
      'As soon as you sign in, you can view your attendance summary, check-in or check-out status, and today\'s active shift.';

  @override
  String get onboardingProofTitle => 'Record attendance with clear proof';

  @override
  String get onboardingProofDescription =>
      'The check-in and check-out flow is ready to submit live location, notes, and photo proof in line with company policy.';

  @override
  String get justInTimePermissionsTitle =>
      'Camera and location appear only when they matter';

  @override
  String get justInTimePermissionsDescription =>
      'Device permission is requested right before you capture selfie proof or attach coordinates, so the flow stays transparent and easy to trust.';

  @override
  String get onboardingHistoryTitle => 'History stays easy to scan';

  @override
  String get onboardingHistoryDescription =>
      'Review clock-in time, clock-out time, late arrivals, and early departures in one tidy summary.';

  @override
  String get onboardingPermissionsTitle => 'Device access consent';

  @override
  String get onboardingPermissionsDescription =>
      'Before using attendance features, we want to make sure you understand why the app needs location and camera access.';

  @override
  String get onboardingLocationConsentTitle => 'Allow location access';

  @override
  String get onboardingLocationConsentDescription =>
      'Location is used to attach coordinates during check-in and check-out so attendance can be verified according to work policy.';

  @override
  String get onboardingCameraConsentTitle => 'Allow camera access';

  @override
  String get onboardingCameraConsentDescription =>
      'Camera access is used to capture photo proof on every check-in and check-out so attendance records stay accurate.';

  @override
  String get onboardingPermissionHint =>
      'After you agree here, your device may still ask for the official system permission the first time each feature is used.';

  @override
  String get onboardingConsentRequired =>
      'Agree to location and camera access before continuing to login.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Sign in with my account';

  @override
  String get skipIntro => 'Skip intro';

  @override
  String get backToOnboarding => 'Back to intro';

  @override
  String get loginCardTitle => 'Sign in to Presense';

  @override
  String get loginCardDescription =>
      'Use your employee account to review today\'s status, record attendance, and open history quickly.';

  @override
  String get permissionUsageSummary =>
      'Camera and location are requested only during check-in or check-out, not on the sign-in screen.';

  @override
  String get showAdvancedSettings => 'Show advanced settings';

  @override
  String get apiBaseUrl => 'API Base URL';

  @override
  String get apiBaseUrlRequired => 'API base URL is required.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email is required.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Password is required.';

  @override
  String get tenantCodeLabel => 'Tenant Code';

  @override
  String get tenantCodeRequired => 'Tenant code is required.';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get showPassword => 'Show password';

  @override
  String get signIn => 'Sign in';

  @override
  String get unableToSignIn => 'Unable to sign in.';

  @override
  String get apiUrlHint =>
      'Tip: You can override the API URL here for emulator, simulator, or local device testing.';

  @override
  String get signedInSuccessfully => 'Signed in successfully.';

  @override
  String get signedOut => 'Signed out.';

  @override
  String get checkInSuccess =>
      'Check-in recorded successfully with photo proof.';

  @override
  String get checkOutSuccess =>
      'Check-out recorded successfully with photo proof.';

  @override
  String get syncingAttendanceData => 'Syncing attendance data...';

  @override
  String get employeeFallback => 'Employee';

  @override
  String get attendanceDashboard => 'Attendance overview';

  @override
  String employeeNoLabel(Object value) {
    return 'Employee No: $value';
  }

  @override
  String get todaySummary => 'Today\'s summary';

  @override
  String get noSummary => 'No summary data is available yet.';

  @override
  String get todayStatus => 'Today\'s Status';

  @override
  String get todayStatusNotCheckedIn => 'Not checked in yet';

  @override
  String get todayStatusCheckedIn => 'Checked in';

  @override
  String get todayStatusCheckedOut => 'Checked out';

  @override
  String get todayStatusNotCheckedInDescription =>
      'You have not recorded attendance yet today.';

  @override
  String get todayStatusCheckedInDescription =>
      'Your check-in is recorded. Check out when your workday is complete.';

  @override
  String get todayStatusCheckedOutDescription =>
      'Your attendance is complete for today.';

  @override
  String get attendanceDate => 'Attendance Date';

  @override
  String get checkedIn => 'Checked In';

  @override
  String get checkedOut => 'Checked Out';

  @override
  String get yesLabel => 'Yes';

  @override
  String get noLabel => 'No';

  @override
  String get noAttendanceActivity =>
      'No attendance activity recorded yet today.';

  @override
  String lastActivity(Object type, Object loggedAt) {
    return 'Last activity: $type at $loggedAt';
  }

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String get loadingAttendanceState => 'Checking your attendance status.';

  @override
  String get checkInAlreadyRecorded =>
      'Check-in is already recorded for today.';

  @override
  String get checkInUnavailableHint =>
      'Check-in is not available yet. Review today\'s status or refresh again in a moment.';

  @override
  String get checkOutRequiresCheckIn =>
      'Check-out becomes available after you check in.';

  @override
  String get checkOutAlreadyRecorded =>
      'Check-out is already recorded for today.';

  @override
  String get checkOutUnavailableHint =>
      'Check-out is not available yet. Review your shift and attendance status first.';

  @override
  String get shiftToday => 'Shift Today';

  @override
  String get noShiftScheduled => 'No shift scheduled today.';

  @override
  String get unnamedShift => 'Unnamed shift';

  @override
  String startLabel(Object value) {
    return 'Start: $value';
  }

  @override
  String endLabel(Object value) {
    return 'End: $value';
  }

  @override
  String get attendancePolicy => 'Attendance Policy';

  @override
  String get noPolicy => 'No policy data available.';

  @override
  String timezoneLabel(Object value) {
    return 'Timezone: $value';
  }

  @override
  String checkInRange(Object start, Object end) {
    return 'Check-in: $start - $end';
  }

  @override
  String checkOutRange(Object start, Object end) {
    return 'Check-out: $start - $end';
  }

  @override
  String get profile => 'Profile';

  @override
  String get employeeProfileMissing =>
      'Employee profile not found for this user.';

  @override
  String nameLabel(Object value) {
    return 'Name: $value';
  }

  @override
  String emailValue(Object value) {
    return 'Email: $value';
  }

  @override
  String statusLabel(Object value) {
    return 'Status: $value';
  }

  @override
  String get photoProofRequired =>
      'Photo proof: required on every check-in and check-out';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get viewAllHistory => 'View all';

  @override
  String get noRecentLogs => 'No recent logs';

  @override
  String get noRecentLogsDescription =>
      'Your latest attendance actions will show up here.';

  @override
  String get confirmCheckIn => 'Confirm check-in';

  @override
  String get confirmCheckOut => 'Confirm check-out';

  @override
  String get checkInSheetDescription =>
      'Complete the final details, capture selfie proof, and submit your check-in in one flow.';

  @override
  String get checkOutSheetDescription =>
      'Capture selfie proof and submit check-out when your workday is complete.';

  @override
  String get addressLabel => 'Address';

  @override
  String get notesLabel => 'Notes';

  @override
  String get deviceNameLabel => 'Device name';

  @override
  String get selfieProofTitle => 'Selfie proof';

  @override
  String get selfieAttached => 'Selfie proof is ready to submit.';

  @override
  String get selfieRequiredHint =>
      'Capture a selfie before you submit attendance.';

  @override
  String get captureSelfie => 'Capture selfie';

  @override
  String get retakeSelfie => 'Retake selfie';

  @override
  String get removeSelfie => 'Remove';

  @override
  String get submittingAttendance => 'Submitting attendance...';

  @override
  String get submitCheckIn => 'Submit check-in';

  @override
  String get submitCheckOut => 'Submit check-out';

  @override
  String get cancel => 'Cancel';

  @override
  String get submit => 'Submit';

  @override
  String get unableToLoadHistory => 'Unable to load history';

  @override
  String get historyLoadErrorHint =>
      'Refresh again to load your attendance history.';

  @override
  String get noAttendanceLogsYet => 'No attendance logs yet';

  @override
  String get noAttendanceLogsDescription =>
      'Your attendance history will appear here after you check in or check out.';

  @override
  String get noRecord => 'No record';

  @override
  String get lateClockIn => 'Late clock in';

  @override
  String get earlyClockOut => 'Early clock out';

  @override
  String get noClockIn => 'No clock in';

  @override
  String get noClockOut => 'No clock out';

  @override
  String get weekend => 'Weekend';

  @override
  String get workShift => 'Work shift';

  @override
  String get noAttendanceRecord => 'No attendance record';

  @override
  String get statusToneLoadingTitle => 'Preparing today\'s status';

  @override
  String get statusToneLoadingDescription =>
      'One moment. We are checking your latest attendance data.';

  @override
  String get statusToneReadyTitle => 'Ready to check in';

  @override
  String get statusToneReadyDescription =>
      'Review your details, capture selfie proof, and submit attendance.';

  @override
  String get statusToneCheckedInTitle => 'Check-in recorded';

  @override
  String get statusToneCheckedInDescription =>
      'Your attendance is active. Remember to check out later.';

  @override
  String get statusToneDoneTitle => 'All set for today';

  @override
  String get statusToneDoneDescription =>
      'Your check-in and check-out are both recorded for today.';

  @override
  String get historySummaryTitle => 'History overview';

  @override
  String get historySummaryDescription =>
      'Review monthly attendance patterns and open each workday in one tap.';
}
