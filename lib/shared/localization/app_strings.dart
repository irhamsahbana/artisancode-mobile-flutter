class AppStrings {
  const AppStrings(this.languageCode);

  final String languageCode;

  bool get isIndonesian => languageCode == 'id';

  String get languageLabel => isIndonesian ? 'Bahasa' : 'Language';
  String get indonesianLabel => isIndonesian ? 'Indonesia' : 'Indonesian';
  String get englishLabel => 'English';
  String get refreshTooltip => isIndonesian ? 'Muat ulang' : 'Refresh';
  String get signOutTooltip => isIndonesian ? 'Keluar' : 'Sign out';
  String get homeTab => isIndonesian ? 'Beranda' : 'Home';
  String get historyTab => isIndonesian ? 'Riwayat' : 'History';
  String get employeeAttendanceTitle => isIndonesian ? 'Absensi Karyawan' : 'Employee Attendance';
  String get loginDescription => isIndonesian
      ? 'Masuk dengan akun karyawan Anda untuk melihat ringkasan absensi, check-in, check-out, dan riwayat.'
      : 'Sign in with your employee account to access attendance summary, check-in, check-out, and history.';
  String get apiBaseUrl => isIndonesian ? 'Base URL API' : 'API Base URL';
  String get apiBaseUrlRequired => isIndonesian ? 'Base URL API wajib diisi.' : 'API base URL is required.';
  String get emailLabel => 'Email';
  String get emailRequired => isIndonesian ? 'Email wajib diisi.' : 'Email is required.';
  String get passwordLabel => isIndonesian ? 'Kata Sandi' : 'Password';
  String get passwordRequired => isIndonesian ? 'Kata sandi wajib diisi.' : 'Password is required.';
  String get tenantCodeLabel => isIndonesian ? 'Kode Tenant' : 'Tenant Code';
  String get tenantCodeRequired => isIndonesian ? 'Kode tenant wajib diisi.' : 'Tenant code is required.';
  String get hidePassword => isIndonesian ? 'Sembunyikan kata sandi' : 'Hide password';
  String get showPassword => isIndonesian ? 'Tampilkan kata sandi' : 'Show password';
  String get signIn => isIndonesian ? 'Masuk' : 'Sign in';
  String get unableToSignIn => isIndonesian ? 'Tidak bisa masuk saat ini.' : 'Unable to sign in.';
  String get apiUrlHint => isIndonesian
      ? 'Tips: Anda bisa mengganti URL API di sini untuk emulator, simulator, atau pengujian perangkat lokal.'
      : 'Tip: You can override the API URL here for emulator, simulator, or local device testing.';
  String get signedInSuccessfully => isIndonesian ? 'Berhasil masuk.' : 'Signed in successfully.';
  String get signedOut => isIndonesian ? 'Berhasil keluar.' : 'Signed out.';
  String get checkInSuccess => isIndonesian
      ? 'Check-in berhasil dicatat dengan bukti foto.'
      : 'Check-in recorded successfully with photo proof.';
  String get checkOutSuccess => isIndonesian
      ? 'Check-out berhasil dicatat dengan bukti foto.'
      : 'Check-out recorded successfully with photo proof.';
  String get employeeFallback => isIndonesian ? 'Karyawan' : 'Employee';
  String get attendanceDashboard => isIndonesian ? 'Dashboard absensi' : 'Attendance dashboard';
  String employeeNoLabel(String value) => isIndonesian ? 'No Karyawan: $value' : 'Employee No: $value';
  String get todaySummary => isIndonesian ? 'Ringkasan Hari Ini' : 'Today Summary';
  String get noSummary => isIndonesian ? 'Belum ada data ringkasan.' : 'No summary data is available yet.';
  String get attendanceDate => isIndonesian ? 'Tanggal Absensi' : 'Attendance Date';
  String get checkedIn => isIndonesian ? 'Sudah Check-in' : 'Checked In';
  String get checkedOut => isIndonesian ? 'Sudah Check-out' : 'Checked Out';
  String yesNo(bool value) => value ? (isIndonesian ? 'Ya' : 'Yes') : (isIndonesian ? 'Tidak' : 'No');
  String get noAttendanceActivity => isIndonesian
      ? 'Belum ada aktivitas absensi yang tercatat hari ini.'
      : 'No attendance activity recorded yet today.';
  String lastActivity(String type, String loggedAt) => isIndonesian
      ? 'Aktivitas terakhir: $type pada $loggedAt'
      : 'Last activity: $type at $loggedAt';
  String get checkIn => 'Check In';
  String get checkOut => 'Check Out';
  String get shiftToday => isIndonesian ? 'Shift Hari Ini' : 'Shift Today';
  String get noShiftScheduled => isIndonesian ? 'Tidak ada shift terjadwal hari ini.' : 'No shift scheduled today.';
  String get unnamedShift => isIndonesian ? 'Shift tanpa nama' : 'Unnamed shift';
  String startLabel(String value) => isIndonesian ? 'Mulai: $value' : 'Start: $value';
  String endLabel(String value) => isIndonesian ? 'Selesai: $value' : 'End: $value';
  String get attendancePolicy => isIndonesian ? 'Kebijakan Absensi' : 'Attendance Policy';
  String get noPolicy => isIndonesian ? 'Data kebijakan tidak tersedia.' : 'No policy data available.';
  String timezoneLabel(String value) => 'Timezone: $value';
  String checkInRange(String start, String end) => 'Check-in: $start - $end';
  String checkOutRange(String start, String end) => 'Check-out: $start - $end';
  String get profile => isIndonesian ? 'Profil' : 'Profile';
  String get employeeProfileMissing => isIndonesian
      ? 'Profil karyawan tidak ditemukan untuk pengguna ini.'
      : 'Employee profile not found for this user.';
  String nameLabel(String value) => isIndonesian ? 'Nama: $value' : 'Name: $value';
  String emailValue(String value) => 'Email: $value';
  String statusLabel(String value) => isIndonesian ? 'Status: $value' : 'Status: $value';
  String get photoProofRequired => isIndonesian
      ? 'Bukti foto: wajib di setiap check-in dan check-out'
      : 'Photo proof: required on every check-in and check-out';
  String get recentActivity => isIndonesian ? 'Aktivitas Terbaru' : 'Recent Activity';
  String get noRecentLogs => isIndonesian ? 'Belum ada log terbaru' : 'No recent logs';
  String get noRecentLogsDescription => isIndonesian
      ? 'Aksi absensi terbaru Anda akan muncul di sini.'
      : 'Your latest attendance actions will show up here.';
  String get confirmCheckIn => isIndonesian ? 'Konfirmasi Check In' : 'Confirm Check In';
  String get confirmCheckOut => isIndonesian ? 'Konfirmasi Check Out' : 'Confirm Check Out';
  String get addressLabel => isIndonesian ? 'Alamat' : 'Address';
  String get notesLabel => isIndonesian ? 'Catatan' : 'Notes';
  String get deviceNameLabel => isIndonesian ? 'Nama perangkat' : 'Device name';
  String get cancel => isIndonesian ? 'Batal' : 'Cancel';
  String get submit => isIndonesian ? 'Kirim' : 'Submit';
  String get unableToLoadHistory => isIndonesian ? 'Tidak dapat memuat riwayat' : 'Unable to load history';
  String get noAttendanceLogsYet => isIndonesian ? 'Belum ada log absensi' : 'No attendance logs yet';
  String get noAttendanceLogsDescription => isIndonesian
      ? 'Riwayat absensi Anda akan muncul di sini setelah check-in atau check-out.'
      : 'Your attendance history will appear here after you check in or check out.';
  String get noRecord => isIndonesian ? 'Tanpa catatan' : 'No record';
  String get lateClockIn => isIndonesian ? 'Terlambat masuk' : 'Late clock in';
  String get earlyClockOut => isIndonesian ? 'Pulang awal' : 'Early clock out';
  String get noClockIn => isIndonesian ? 'Tidak check-in' : 'No clock in';
  String get noClockOut => isIndonesian ? 'Tidak check-out' : 'No clock out';
}
