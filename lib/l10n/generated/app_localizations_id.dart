// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get languageLabel => 'Bahasa';

  @override
  String get indonesianLabel => 'Indonesia';

  @override
  String get englishLabel => 'Inggris';

  @override
  String get refreshTooltip => 'Muat ulang';

  @override
  String get signOutTooltip => 'Keluar';

  @override
  String get homeTab => 'Beranda';

  @override
  String get historyTab => 'Riwayat';

  @override
  String get employeeAttendanceTitle => 'Absensi Karyawan';

  @override
  String get loginDescription =>
      'Masuk dengan akun karyawan Anda untuk melihat ringkasan absensi, check-in, check-out, dan riwayat.';

  @override
  String get apiBaseUrl => 'Base URL API';

  @override
  String get apiBaseUrlRequired => 'Base URL API wajib diisi.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email wajib diisi.';

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get passwordRequired => 'Kata sandi wajib diisi.';

  @override
  String get tenantCodeLabel => 'Kode Tenant';

  @override
  String get tenantCodeRequired => 'Kode tenant wajib diisi.';

  @override
  String get hidePassword => 'Sembunyikan kata sandi';

  @override
  String get showPassword => 'Tampilkan kata sandi';

  @override
  String get signIn => 'Masuk';

  @override
  String get unableToSignIn => 'Tidak bisa masuk saat ini.';

  @override
  String get apiUrlHint =>
      'Tips: Anda bisa mengganti URL API di sini untuk emulator, simulator, atau pengujian perangkat lokal.';

  @override
  String get signedInSuccessfully => 'Berhasil masuk.';

  @override
  String get signedOut => 'Berhasil keluar.';

  @override
  String get checkInSuccess => 'Check-in berhasil dicatat dengan bukti foto.';

  @override
  String get checkOutSuccess => 'Check-out berhasil dicatat dengan bukti foto.';

  @override
  String get employeeFallback => 'Karyawan';

  @override
  String get attendanceDashboard => 'Dashboard absensi';

  @override
  String employeeNoLabel(Object value) {
    return 'No Karyawan: $value';
  }

  @override
  String get todaySummary => 'Ringkasan Hari Ini';

  @override
  String get noSummary => 'Belum ada data ringkasan.';

  @override
  String get attendanceDate => 'Tanggal Absensi';

  @override
  String get checkedIn => 'Sudah Check-in';

  @override
  String get checkedOut => 'Sudah Check-out';

  @override
  String get yesLabel => 'Ya';

  @override
  String get noLabel => 'Tidak';

  @override
  String get noAttendanceActivity =>
      'Belum ada aktivitas absensi yang tercatat hari ini.';

  @override
  String lastActivity(Object type, Object loggedAt) {
    return 'Aktivitas terakhir: $type pada $loggedAt';
  }

  @override
  String get checkIn => 'Check In';

  @override
  String get checkOut => 'Check Out';

  @override
  String get shiftToday => 'Shift Hari Ini';

  @override
  String get noShiftScheduled => 'Tidak ada shift terjadwal hari ini.';

  @override
  String get unnamedShift => 'Shift tanpa nama';

  @override
  String startLabel(Object value) {
    return 'Mulai: $value';
  }

  @override
  String endLabel(Object value) {
    return 'Selesai: $value';
  }

  @override
  String get attendancePolicy => 'Kebijakan Absensi';

  @override
  String get noPolicy => 'Data kebijakan tidak tersedia.';

  @override
  String timezoneLabel(Object value) {
    return 'Zona waktu: $value';
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
  String get profile => 'Profil';

  @override
  String get employeeProfileMissing =>
      'Profil karyawan tidak ditemukan untuk pengguna ini.';

  @override
  String nameLabel(Object value) {
    return 'Nama: $value';
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
      'Bukti foto: wajib di setiap check-in dan check-out';

  @override
  String get recentActivity => 'Aktivitas Terbaru';

  @override
  String get noRecentLogs => 'Belum ada log terbaru';

  @override
  String get noRecentLogsDescription =>
      'Aksi absensi terbaru Anda akan muncul di sini.';

  @override
  String get confirmCheckIn => 'Konfirmasi Check In';

  @override
  String get confirmCheckOut => 'Konfirmasi Check Out';

  @override
  String get addressLabel => 'Alamat';

  @override
  String get notesLabel => 'Catatan';

  @override
  String get deviceNameLabel => 'Nama perangkat';

  @override
  String get cancel => 'Batal';

  @override
  String get submit => 'Kirim';

  @override
  String get unableToLoadHistory => 'Tidak dapat memuat riwayat';

  @override
  String get noAttendanceLogsYet => 'Belum ada log absensi';

  @override
  String get noAttendanceLogsDescription =>
      'Riwayat absensi Anda akan muncul di sini setelah check-in atau check-out.';

  @override
  String get noRecord => 'Tanpa catatan';

  @override
  String get lateClockIn => 'Terlambat masuk';

  @override
  String get earlyClockOut => 'Pulang awal';

  @override
  String get noClockIn => 'Tidak check-in';

  @override
  String get noClockOut => 'Tidak check-out';

  @override
  String get weekend => 'Akhir pekan';

  @override
  String get workShift => 'Shift kerja';

  @override
  String get noAttendanceRecord => 'Tidak ada catatan absensi';
}
