import 'dart:io';

import 'package:artisan_hr/features/attendance/data/models/attendance_log.dart';
import 'package:artisan_hr/features/attendance/data/models/attendance_policy.dart';
import 'package:artisan_hr/features/attendance/data/models/attendance_summary.dart';
import 'package:artisan_hr/features/attendance/data/models/check_in_request.dart';
import 'package:artisan_hr/features/attendance/data/models/check_out_request.dart';
import 'package:artisan_hr/features/attendance/data/models/employee_profile.dart';
import 'package:artisan_hr/features/attendance/data/models/shift_today.dart';
import 'package:artisan_hr/features/attendance/data/models/upload_target.dart';
import 'package:artisan_hr/features/attendance/data/services/attendance_photo_preparer.dart';
import 'package:artisan_hr/shared/core/api/api_client.dart';

class AttendanceRepository {
  AttendanceRepository({
    required ApiClient apiClient,
    AttendancePhotoPreparer? photoPreparer,
  }) : _apiClient = apiClient,
       _photoPreparer = photoPreparer ?? const AttendancePhotoPreparer();

  final ApiClient _apiClient;
  final AttendancePhotoPreparer _photoPreparer;

  Future<EmployeeProfile?> getEmployeeProfile({
    required String accessToken,
  }) async {
    final response = await _apiClient.get(
      '/me/employee',
      accessToken: accessToken,
    );
    return response.dataOrNull == null
        ? null
        : EmployeeProfile.fromJson(response.requireDataMap());
  }

  Future<AttendanceSummary?> getAttendanceSummary({
    required String accessToken,
  }) async {
    final response = await _apiClient.get(
      '/attendance-summary/today',
      accessToken: accessToken,
    );
    return response.dataOrNull == null
        ? null
        : AttendanceSummary.fromJson(response.requireDataMap());
  }

  Future<AttendancePolicy?> getAttendancePolicy({
    required String accessToken,
  }) async {
    final response = await _apiClient.get(
      '/attendance-policy',
      accessToken: accessToken,
    );
    return response.dataOrNull == null
        ? null
        : AttendancePolicy.fromJson(response.requireDataMap());
  }

  Future<ShiftToday?> getShiftToday({required String accessToken}) async {
    final response = await _apiClient.get(
      '/me/shift-today',
      accessToken: accessToken,
    );
    return response.dataOrNull == null
        ? null
        : ShiftToday.fromJson(response.requireDataMap());
  }

  Future<List<AttendanceLog>> getAttendanceLogs({
    required String accessToken,
    String? dateFrom,
    String? dateTo,
    int limit = 100,
    int page = 1,
  }) async {
    final response = await _apiClient.get(
      '/attendance-logs',
      accessToken: accessToken,
      queryParameters: {
        'date_from': dateFrom,
        'date_to': dateTo,
        'limit': '$limit',
        'page': '$page',
      },
    );
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

  Future<UploadTarget> createAttendanceUploadUrl({
    required String accessToken,
    required String attendanceType,
    required String contentType,
  }) async {
    final response = await _apiClient.post(
      '/storage/upload-url',
      accessToken: accessToken,
      body: {
        'filename': '$attendanceType-selfie',
        'folder': 'attendance-face',
        'content_type': contentType,
        'is_public': false,
      },
    );
    return UploadTarget.fromJson(response.requireDataMap());
  }

  Future<String> uploadAttendancePhoto({
    required String accessToken,
    required String attendanceType,
    required String filePath,
  }) async {
    final preparedFile = await _photoPreparer.prepareForUpload(filePath);
    final uploadPath = preparedFile.path.isEmpty ? filePath : preparedFile.path;
    try {
      final target = await createAttendanceUploadUrl(
        accessToken: accessToken,
        attendanceType: attendanceType,
        contentType: preparedFile.contentType,
      );
      final bytes = await File(uploadPath).readAsBytes();
      await _apiClient.putBinary(
        target.uploadUrl,
        body: bytes,
        contentType: preparedFile.contentType,
        headers: target.headers,
      );
      return target.fileId;
    } finally {
      if (preparedFile.didCompress && uploadPath != filePath) {
        try {
          await File(uploadPath).delete();
        } catch (_) {
          // Ignore temp cleanup failures after upload attempts.
        }
      }
    }
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
