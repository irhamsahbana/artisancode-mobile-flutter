import 'dart:async';

import 'package:flutter/foundation.dart';

import '../features/attendance/data/attendance_repository.dart';
import '../features/attendance/data/models/attendance_log.dart';
import '../features/attendance/data/models/attendance_policy.dart';
import '../features/attendance/data/models/attendance_summary.dart';
import '../features/attendance/data/models/check_in_request.dart';
import '../features/attendance/data/models/check_out_request.dart';
import '../features/attendance/data/models/employee_profile.dart';
import '../features/attendance/data/models/shift_today.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/models/auth_tokens.dart';
import '../features/auth/data/models/login_request.dart';
import '../features/auth/data/models/user_context.dart';
import '../shared/core/api/api_client.dart';
import '../shared/core/errors/app_exception.dart';

class AppController extends ChangeNotifier {
  AppController({required String initialBaseUrl})
      : _baseUrl = initialBaseUrl.trim(),
        _apiClient = ApiClient(baseUrl: initialBaseUrl.trim()),
        _authRepository = AuthRepository(apiClient: ApiClient(baseUrl: initialBaseUrl.trim())),
        _attendanceRepository =
            AttendanceRepository(apiClient: ApiClient(baseUrl: initialBaseUrl.trim()));

  String _baseUrl;
  late ApiClient _apiClient;
  late AuthRepository _authRepository;
  late AttendanceRepository _attendanceRepository;

  bool _isBusy = false;
  String? _errorMessage;
  String? _successMessage;
  int _selectedTabIndex = 0;

  AuthTokens? _tokens;
  UserContext? _user;
  EmployeeProfile? _employee;
  ShiftToday? _shiftToday;
  AttendanceSummary? _summary;
  AttendancePolicy? _policy;
  List<AttendanceLog> _attendanceLogs = const [];

  String get baseUrl => _baseUrl;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  int get selectedTabIndex => _selectedTabIndex;
  bool get isAuthenticated => _tokens != null;
  UserContext? get user => _user;
  EmployeeProfile? get employee => _employee;
  ShiftToday? get shiftToday => _shiftToday;
  AttendanceSummary? get summary => _summary;
  AttendancePolicy? get policy => _policy;
  List<AttendanceLog> get attendanceLogs => List.unmodifiable(_attendanceLogs);

  bool get canCheckIn => _summary?.canCheckIn ?? false;
  bool get canCheckOut => _summary?.canCheckOut ?? false;

  Future<void> login({
    required String email,
    required String password,
    required String tenantCode,
    required String baseUrl,
  }) async {
    _clearMessages();
    _setBusy(true);

    try {
      final normalizedBaseUrl = _normalizeBaseUrl(baseUrl);
      _configureBaseUrl(normalizedBaseUrl);

      final tokens = await _authRepository.login(
        LoginRequest(
          email: email.trim(),
          password: password,
          tenantCode: tenantCode.trim().toUpperCase(),
        ),
      );

      _tokens = tokens;
      await _bootstrapAuthenticatedState();
      _successMessage = 'Signed in successfully.';
    } on AppException catch (error) {
      _errorMessage = error.message;
      rethrow;
    } catch (_) {
      _errorMessage = 'Unable to sign in right now.';
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> logout() async {
    _tokens = null;
    _user = null;
    _employee = null;
    _shiftToday = null;
    _summary = null;
    _policy = null;
    _attendanceLogs = const [];
    _selectedTabIndex = 0;
    _successMessage = 'Signed out.';
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshAll() async {
    if (_tokens == null) return;

    _clearMessages();
    _setBusy(true);

    try {
      await _bootstrapAuthenticatedState(loadLogs: true);
    } on AppException catch (error) {
      _errorMessage = error.message;
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> refreshHistory() async {
    if (_tokens == null) return;

    _clearMessages();
    _setBusy(true);

    try {
      _attendanceLogs = await _attendanceRepository.getAttendanceLogs(
        accessToken: _tokens!.accessToken,
      );
      notifyListeners();
    } on AppException catch (error) {
      _errorMessage = error.message;
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> checkIn({
    required String address,
    required String notes,
    required String deviceName,
  }) async {
    if (_tokens == null) return;

    _clearMessages();
    _setBusy(true);

    try {
      await _attendanceRepository.checkIn(
        accessToken: _tokens!.accessToken,
        request: CheckInRequest(
          loggedAt: DateTime.now(),
          address: address.trim().isEmpty ? null : address.trim(),
          notes: notes.trim().isEmpty ? null : notes.trim(),
          deviceId: defaultTargetPlatform.name,
          deviceName: deviceName.trim().isEmpty ? 'Artisan HR App' : deviceName.trim(),
        ),
      );
      _successMessage = 'Check-in recorded successfully.';
      await _bootstrapAuthenticatedState(loadLogs: true);
    } on AppException catch (error) {
      _errorMessage = error.message;
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> checkOut({required String deviceName}) async {
    if (_tokens == null) return;

    _clearMessages();
    _setBusy(true);

    try {
      await _attendanceRepository.checkOut(
        accessToken: _tokens!.accessToken,
        request: CheckOutRequest(
          loggedAt: DateTime.now(),
          deviceId: defaultTargetPlatform.name,
          deviceName: deviceName.trim().isEmpty ? 'Artisan HR App' : deviceName.trim(),
        ),
      );
      _successMessage = 'Check-out recorded successfully.';
      await _bootstrapAuthenticatedState(loadLogs: true);
    } on AppException catch (error) {
      _errorMessage = error.message;
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  void clearTransientMessages() {
    if (_errorMessage == null && _successMessage == null) return;
    _clearMessages();
    notifyListeners();
  }

  void selectTab(int index) {
    if (_selectedTabIndex == index) return;
    _selectedTabIndex = index;
    notifyListeners();
  }

  Future<void> _bootstrapAuthenticatedState({bool loadLogs = true}) async {
    final accessToken = _tokens?.accessToken;
    if (accessToken == null) return;

    final results = await Future.wait<Object?>([
      _authRepository.getMe(accessToken: accessToken),
      _attendanceRepository.getEmployeeProfile(accessToken: accessToken),
      _attendanceRepository.getAttendanceSummary(accessToken: accessToken),
      _attendanceRepository.getAttendancePolicy(accessToken: accessToken),
      _attendanceRepository.getShiftToday(accessToken: accessToken),
      if (loadLogs)
        _attendanceRepository.getAttendanceLogs(accessToken: accessToken)
      else
        Future<Object?>.value(_attendanceLogs),
    ]);

    _user = results[0] as UserContext;
    _employee = results[1] as EmployeeProfile?;
    _summary = results[2] as AttendanceSummary?;
    _policy = results[3] as AttendancePolicy?;
    _shiftToday = results[4] as ShiftToday?;
    _attendanceLogs = List<AttendanceLog>.from(results[5] as List<AttendanceLog>);
    notifyListeners();
  }

  void _configureBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    _apiClient = ApiClient(baseUrl: baseUrl);
    _authRepository = AuthRepository(apiClient: _apiClient);
    _attendanceRepository = AttendanceRepository(apiClient: _apiClient);
  }

  String _normalizeBaseUrl(String baseUrl) {
    final trimmed = baseUrl.trim();
    if (trimmed.isEmpty) {
      throw const AppException('API base URL is required.');
    }
    return trimmed.endsWith('/') ? trimmed.substring(0, trimmed.length - 1) : trimmed;
  }

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }
}
