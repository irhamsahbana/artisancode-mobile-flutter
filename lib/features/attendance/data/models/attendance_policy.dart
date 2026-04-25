class AttendancePolicy {
  const AttendancePolicy({required this.timezone, required this.radiusMeters});

  final String timezone;
  final int? radiusMeters;

  factory AttendancePolicy.fromJson(Map<String, dynamic> json) {
    return AttendancePolicy(
      timezone: json['timezone'] as String? ?? '-',
      radiusMeters: (json['attendance_radius_meters'] as num?)?.toInt(),
    );
  }
}
