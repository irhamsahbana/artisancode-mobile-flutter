class AttendanceSummary {
  const AttendanceSummary({
    required this.attendanceDate,
    required this.checkedIn,
    required this.checkedOut,
    required this.checkInLogId,
    required this.checkOutLogId,
    required this.lastLogType,
    required this.lastLoggedAt,
    required this.canCheckIn,
    required this.canCheckOut,
  });

  final String attendanceDate;
  final bool checkedIn;
  final bool checkedOut;
  final String? checkInLogId;
  final String? checkOutLogId;
  final String? lastLogType;
  final DateTime? lastLoggedAt;
  final bool canCheckIn;
  final bool canCheckOut;

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      attendanceDate: json['attendance_date'] as String? ?? '-',
      checkedIn: json['checked_in'] as bool? ?? false,
      checkedOut: json['checked_out'] as bool? ?? false,
      checkInLogId: json['check_in_log_id'] as String?,
      checkOutLogId: json['check_out_log_id'] as String?,
      lastLogType: json['last_log_type'] as String?,
      lastLoggedAt: _parseDateTime(json['last_logged_at']),
      canCheckIn: json['can_check_in'] as bool? ?? false,
      canCheckOut: json['can_check_out'] as bool? ?? false,
    );
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
