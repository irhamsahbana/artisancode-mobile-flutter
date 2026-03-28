class AttendanceLog {
  const AttendanceLog({
    required this.id,
    required this.type,
    required this.source,
    required this.loggedAt,
    required this.attendanceDate,
    required this.address,
    required this.notes,
  });

  final String id;
  final String type;
  final String source;
  final DateTime? loggedAt;
  final String attendanceDate;
  final String? address;
  final String? notes;

  factory AttendanceLog.fromJson(Map<String, dynamic> json) {
    return AttendanceLog(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '-',
      source: json['source'] as String? ?? '-',
      loggedAt: _parseDateTime(json['logged_at']),
      attendanceDate: json['attendance_date'] as String? ?? '-',
      address: json['address'] as String?,
      notes: json['notes'] as String?,
    );
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
