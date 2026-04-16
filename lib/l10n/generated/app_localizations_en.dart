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
  String get homeTab => 'Home';

  @override
  String get historyTab => 'History';

  @override
  String get employeeAttendanceTitle => 'Employee Attendance';

  @override
  String get loginDescription =>
      'Sign in with your employee account to access attendance summary, check-in, check-out, and history.';

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
  String get employeeFallback => 'Employee';

  @override
  String get attendanceDashboard => 'Attendance dashboard';

  @override
  String employeeNoLabel(Object value) {
    return 'Employee No: $value';
  }

  @override
  String get todaySummary => 'Today Summary';

  @override
  String get noSummary => 'No summary data is available yet.';

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
  String get checkIn => 'Check In';

  @override
  String get checkOut => 'Check Out';

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
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentLogs => 'No recent logs';

  @override
  String get noRecentLogsDescription =>
      'Your latest attendance actions will show up here.';

  @override
  String get confirmCheckIn => 'Confirm Check In';

  @override
  String get confirmCheckOut => 'Confirm Check Out';

  @override
  String get addressLabel => 'Address';

  @override
  String get notesLabel => 'Notes';

  @override
  String get deviceNameLabel => 'Device name';

  @override
  String get cancel => 'Cancel';

  @override
  String get submit => 'Submit';

  @override
  String get unableToLoadHistory => 'Unable to load history';

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
}
