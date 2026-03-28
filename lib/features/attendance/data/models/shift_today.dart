class ShiftToday {
  const ShiftToday({
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.attendanceDate,
  });

  final String? shiftId;
  final String? shiftName;
  final String? startTime;
  final String? endTime;
  final String? attendanceDate;

  factory ShiftToday.fromJson(Map<String, dynamic> json) {
    return ShiftToday(
      shiftId: json['shift_id'] as String?,
      shiftName: json['shift_name'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      attendanceDate: json['attendance_date'] as String?,
    );
  }
}
