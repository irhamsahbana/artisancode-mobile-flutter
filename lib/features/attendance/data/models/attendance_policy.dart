class AttendancePolicy {
  const AttendancePolicy({
    required this.timezone,
    required this.radiusMeters,
    required this.checkInStart,
    required this.checkInEnd,
    required this.checkOutStart,
    required this.checkOutEnd,
  });

  final String timezone;
  final int? radiusMeters;
  final String? checkInStart;
  final String? checkInEnd;
  final String? checkOutStart;
  final String? checkOutEnd;

  factory AttendancePolicy.fromJson(Map<String, dynamic> json) {
    return AttendancePolicy(
      timezone: json['timezone'] as String? ?? '-',
      radiusMeters: (json['attendance_radius_meters'] as num?)?.toInt(),
      checkInStart: json['attendance_check_in_start'] as String?,
      checkInEnd: json['attendance_check_in_end'] as String?,
      checkOutStart: json['attendance_check_out_start'] as String?,
      checkOutEnd: json['attendance_check_out_end'] as String?,
    );
  }
}
