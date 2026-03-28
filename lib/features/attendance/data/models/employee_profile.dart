class EmployeeProfile {
  const EmployeeProfile({
    required this.id,
    required this.employeeNo,
    required this.fullName,
    required this.email,
    required this.status,
    required this.orgUnitId,
    required this.jobPositionId,
    required this.locationId,
    required this.shiftId,
  });

  final String id;
  final String? employeeNo;
  final String fullName;
  final String? email;
  final String? status;
  final String? orgUnitId;
  final String? jobPositionId;
  final String? locationId;
  final String? shiftId;

  factory EmployeeProfile.fromJson(Map<String, dynamic> json) {
    return EmployeeProfile(
      id: json['id'] as String? ?? '',
      employeeNo: json['employee_no'] as String?,
      fullName: json['full_name'] as String? ?? '-',
      email: json['email'] as String?,
      status: json['status'] as String?,
      orgUnitId: json['org_unit_id'] as String?,
      jobPositionId: json['job_position_id'] as String?,
      locationId: json['location_id'] as String?,
      shiftId: json['shift_id'] as String?,
    );
  }
}
