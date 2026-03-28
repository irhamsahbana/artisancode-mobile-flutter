import '../../../shared/core/api/api_client.dart';
import 'models/attendance_log.dart';
import 'models/attendance_policy.dart';
import 'models/attendance_summary.dart';
import 'models/check_in_request.dart';
import 'models/check_out_request.dart';
import 'models/employee_profile.dart';
import 'models/shift_today.dart';

class AttendanceRepository {
  AttendanceRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<EmployeeProfile?> getEmployeeProfile({required String accessToken}) async {
    final response = await _apiClient.get('/me/employee', accessToken: accessToken);
    return response.dataOrNull == null
        ? null
        : EmployeeProfile.fromJson(response.requireDataMap());
  }

  Future<AttendanceSummary?> getAttendanceSummary({
    required String accessToken,
  }) async {
    final response =
        await _apiClient.get('/attendance-summary/today', accessToken: accessToken);
    return response.dataOrNull == null
        ? null
        : AttendanceSummary.fromJson(response.requireDataMap());
  }

  Future<AttendancePolicy?> getAttendancePolicy({
    required String accessToken,
  }) async {
    final response =
        await _apiClient.get('/attendance-policy', accessToken: accessToken);
    return response.dataOrNull == null
        ? null
        : AttendancePolicy.fromJson(response.requireDataMap());
  }

  Future<ShiftToday?> getShiftToday({required String accessToken}) async {
    final response = await _apiClient.get('/me/shift-today', accessToken: accessToken);
    return response.dataOrNull == null ? null : ShiftToday.fromJson(response.requireDataMap());
  }

  Future<List<AttendanceLog>> getAttendanceLogs({required String accessToken}) async {
    final response = await _apiClient.get('/attendance-logs', accessToken: accessToken);
    final data = response.dataOrNull;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(AttendanceLog.fromJson)
          .toList(growable: false);
    }
    if (data is Map<String, dynamic>) {
      final items = data['items'] ?? data['data'] ?? data['rows'];
      if (items is List) {
        return items
            .whereType<Map<String, dynamic>>()
            .map(AttendanceLog.fromJson)
            .toList(growable: false);
      }
    }
    return const [];
  }

  Future<void> checkIn({
    required String accessToken,
    required CheckInRequest request,
  }) async {
    await _apiClient.post(
      '/attendance-logs/check-in',
      accessToken: accessToken,
      body: request.toJson(),
    );
  }

  Future<void> checkOut({
    required String accessToken,
    required CheckOutRequest request,
  }) async {
    await _apiClient.post(
      '/attendance-logs/check-out',
      accessToken: accessToken,
      body: request.toJson(),
    );
  }
}
