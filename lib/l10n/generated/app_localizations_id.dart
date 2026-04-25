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
  String get moreActions => 'Aksi lainnya';

  @override
  String get homeTab => 'Hari ini';

  @override
  String get historyTab => 'Riwayat';

  @override
  String get employeeAttendanceTitle => 'Kehadiran hari ini';

  @override
  String get loginDescription =>
      'Masuk dengan akun karyawan Anda untuk melihat ringkasan absensi, check-in, check-out, dan riwayat.';

  @override
  String get onboardingBadge => 'Absensi yang terasa jelas';

  @override
  String get onboardingHeadline =>
      'Check-in lebih jelas. Hari kerja lebih tertata.';

  @override
  String get onboardingSubheadline =>
      'Presense membantu Anda melihat status hari ini, mencatat kehadiran dengan bukti yang benar, dan meninjau riwayat tanpa banyak langkah.';

  @override
  String get onboardingAttendanceTitle => 'Lihat status hari ini dengan cepat';

  @override
  String get onboardingAttendanceDescription =>
      'Begitu masuk, Anda langsung melihat ringkasan absensi, status check-in atau check-out, dan shift yang sedang berlaku.';

  @override
  String get onboardingProofTitle => 'Catat kehadiran dengan bukti yang jelas';

  @override
  String get onboardingProofDescription =>
      'Alur check-in dan check-out disiapkan untuk mengirim lokasi aktif, catatan, dan bukti foto sesuai kebijakan perusahaan.';

  @override
  String get justInTimePermissionsTitle =>
      'Kamera dan lokasi dipakai saat benar-benar diperlukan';

  @override
  String get justInTimePermissionsDescription =>
      'Izin perangkat diminta tepat sebelum Anda mengambil selfie bukti atau melampirkan koordinat, jadi alurnya terasa jujur dan mudah dipahami.';

  @override
  String get onboardingHistoryTitle => 'Riwayat kehadiran tetap mudah dibaca';

  @override
  String get onboardingHistoryDescription =>
      'Lihat jam masuk, jam pulang, keterlambatan, dan pulang awal dalam satu rangkuman yang rapi.';

  @override
  String get onboardingPermissionsTitle => 'Persetujuan akses perangkat';

  @override
  String get onboardingPermissionsDescription =>
      'Sebelum memakai absensi, kami ingin memastikan Anda paham kenapa aplikasi membutuhkan lokasi dan kamera.';

  @override
  String get onboardingLocationConsentTitle => 'Izinkan akses lokasi';

  @override
  String get onboardingLocationConsentDescription =>
      'Lokasi dipakai untuk melampirkan koordinat saat check-in dan check-out agar kehadiran dapat diverifikasi sesuai kebijakan kerja.';

  @override
  String get onboardingCameraConsentTitle => 'Izinkan akses kamera';

  @override
  String get onboardingCameraConsentDescription =>
      'Kamera dipakai untuk mengambil bukti foto setiap kali check-in atau check-out sehingga catatan absensi lebih akurat.';

  @override
  String get onboardingPermissionHint =>
      'Setelah Anda setuju di sini, sistem perangkat tetap bisa meminta izin resmi saat fitur pertama kali dipakai.';

  @override
  String get onboardingConsentRequired =>
      'Setujui akses lokasi dan kamera untuk melanjutkan ke login.';

  @override
  String get onboardingNext => 'Lanjut';

  @override
  String get onboardingGetStarted => 'Masuk dengan akun saya';

  @override
  String get skipIntro => 'Lewati';

  @override
  String get backToOnboarding => 'Kembali ke pengantar';

  @override
  String get loginCardTitle => 'Masuk ke Presense';

  @override
  String get loginCardDescription =>
      'Gunakan akun karyawan Anda untuk melihat status hari ini, mencatat kehadiran, dan membuka riwayat dengan cepat.';

  @override
  String get permissionUsageSummary =>
      'Kamera dan lokasi hanya diminta saat Anda check-in atau check-out, bukan saat layar masuk dibuka.';

  @override
  String get showAdvancedSettings => 'Tampilkan pengaturan lanjutan';

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
  String get syncingAttendanceData => 'Menyinkronkan data absensi...';

  @override
  String get employeeFallback => 'Karyawan';

  @override
  String get attendanceDashboard => 'Ringkasan kehadiran';

  @override
  String employeeNoLabel(Object value) {
    return 'No Karyawan: $value';
  }

  @override
  String get todaySummary => 'Ringkasan hari ini';

  @override
  String get noSummary => 'Belum ada data ringkasan.';

  @override
  String get todayStatus => 'Status Hari Ini';

  @override
  String get todayStatusNotCheckedIn => 'Belum check-in';

  @override
  String get todayStatusCheckedIn => 'Sudah check-in';

  @override
  String get todayStatusCheckedOut => 'Sudah check-out';

  @override
  String get todayStatusNotCheckedInDescription =>
      'Anda belum mencatat kehadiran hari ini.';

  @override
  String get todayStatusCheckedInDescription =>
      'Check-in sudah tercatat. Lanjutkan check-out saat jam kerja selesai.';

  @override
  String get todayStatusCheckedOutDescription =>
      'Check-in dan check-out hari ini sudah lengkap.';

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
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String get loadingAttendanceState => 'Memeriksa status kehadiran Anda.';

  @override
  String get checkInAlreadyRecorded => 'Check-in hari ini sudah tercatat.';

  @override
  String get checkInUnavailableHint =>
      'Check-in belum tersedia. Tinjau status hari ini atau muat ulang sebentar lagi.';

  @override
  String get checkOutRequiresCheckIn =>
      'Check-out baru tersedia setelah Anda check-in.';

  @override
  String get checkOutAlreadyRecorded => 'Check-out hari ini sudah tercatat.';

  @override
  String get checkOutUnavailableHint =>
      'Check-out belum tersedia. Tinjau shift dan status absensi Anda terlebih dulu.';

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
  String attendanceRadiusLabel(Object value) {
    return 'Radius absensi: $value m';
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
  String get recentActivity => 'Aktivitas terbaru';

  @override
  String get viewAllHistory => 'Lihat semua';

  @override
  String get noRecentLogs => 'Belum ada log terbaru';

  @override
  String get noRecentLogsDescription =>
      'Aksi absensi terbaru Anda akan muncul di sini.';

  @override
  String get confirmCheckIn => 'Konfirmasi check-in';

  @override
  String get confirmCheckOut => 'Konfirmasi check-out';

  @override
  String get checkInSheetDescription =>
      'Lengkapi detail akhir, ambil selfie bukti, lalu kirim check-in dalam satu alur.';

  @override
  String get checkOutSheetDescription =>
      'Ambil selfie bukti lalu kirim check-out saat hari kerja selesai.';

  @override
  String get addressLabel => 'Alamat';

  @override
  String get notesLabel => 'Catatan';

  @override
  String get deviceNameLabel => 'Nama perangkat';

  @override
  String get selfieProofTitle => 'Bukti selfie';

  @override
  String get selfieAttached => 'Bukti selfie sudah siap dikirim.';

  @override
  String get selfieRequiredHint => 'Ambil selfie sebelum mengirim absensi.';

  @override
  String get captureSelfie => 'Ambil selfie';

  @override
  String get retakeSelfie => 'Ambil ulang';

  @override
  String get removeSelfie => 'Hapus';

  @override
  String get submittingAttendance => 'Mengirim kehadiran...';

  @override
  String get submitCheckIn => 'Kirim check-in';

  @override
  String get submitCheckOut => 'Kirim check-out';

  @override
  String get cancel => 'Batal';

  @override
  String get submit => 'Kirim';

  @override
  String get unableToLoadHistory => 'Tidak dapat memuat riwayat';

  @override
  String get historyLoadErrorHint =>
      'Muat ulang lagi untuk mengambil riwayat absensi Anda.';

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

  @override
  String get statusToneLoadingTitle => 'Sedang menyiapkan status hari ini';

  @override
  String get statusToneLoadingDescription =>
      'Tunggu sebentar. Kami sedang memeriksa data kehadiran terbaru Anda.';

  @override
  String get statusToneReadyTitle => 'Siap untuk check-in';

  @override
  String get statusToneReadyDescription =>
      'Periksa detail, ambil selfie bukti, lalu kirim kehadiran Anda.';

  @override
  String get statusToneCheckedInTitle => 'Check-in sudah masuk';

  @override
  String get statusToneCheckedInDescription =>
      'Kehadiran Anda sedang aktif. Jangan lupa check-out nanti.';

  @override
  String get statusToneDoneTitle => 'Hari ini sudah lengkap';

  @override
  String get statusToneDoneDescription =>
      'Check-in dan check-out Anda sudah tercatat untuk hari ini.';

  @override
  String get historySummaryTitle => 'Ringkasan riwayat';

  @override
  String get historySummaryDescription =>
      'Tinjau pola kehadiran bulanan dan buka detail hari kerja Anda dengan cepat.';
}
