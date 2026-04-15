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
import '../shared/core/logging/app_logger.dart';
import '../shared/localization/app_strings.dart';

class AppController extends ChangeNotifier {
  AppController({required String initialBaseUrl})
    : _baseUrl = initialBaseUrl.trim(),
      _apiClient = ApiClient(baseUrl: initialBaseUrl.trim()),
      _authRepository = AuthRepository(
        apiClient: ApiClient(baseUrl: initialBaseUrl.trim()),
      ),
      _attendanceRepository = AttendanceRepository(
        apiClient: ApiClient(baseUrl: initialBaseUrl.trim()),
      ) {
    appLogger.i(
      formatLogMessage(
        'app_controller.init',
        message: 'AppController created.',
        details: <String, Object?>{
          'baseUrl': _baseUrl,
        },
      ),
    );
  }

  String _baseUrl;
  late ApiClient _apiClient;
  late AuthRepository _authRepository;
  late AttendanceRepository _attendanceRepository;

  bool _isBusy = false;
  String? _errorMessage;
  String? _successMessage;
  int _selectedTabIndex = 0;
  String _languageCode = 'id';

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
  String get languageCode => _languageCode;
  AppStrings get strings => AppStrings(_languageCode);
  bool get isAuthenticated => _tokens != null;
  UserContext? get user => _user;
  EmployeeProfile? get employee => _employee;
  ShiftToday? get shiftToday => _shiftToday;
  AttendanceSummary? get summary => _summary;
  AttendancePolicy? get policy => _policy;
  List<AttendanceLog> get attendanceLogs => List.unmodifiable(_attendanceLogs);

  bool get canCheckIn => _summary?.canCheckIn ?? false;
  bool get canCheckOut => _summary?.canCheckOut ?? false;

  void setLanguage(String languageCode) {
    final nextLanguageCode = languageCode == 'en' ? 'en' : 'id';
    if (_languageCode == nextLanguageCode) return;
    _languageCode = nextLanguageCode;
    appLogger.i(
      formatLogMessage(
        'language.changed',
        details: <String, Object?>{
          'languageCode': _languageCode,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
    required String tenantCode,
    required String baseUrl,
  }) async {
    _clearMessages();
    _setBusy(true);
    final stopwatch = Stopwatch()..start();
    appLogger.i(
      formatLogMessage(
        'auth.login.started',
        details: <String, Object?>{
          'email': email.trim(),
          'tenantCode': tenantCode.trim().toUpperCase(),
          'baseUrl': baseUrl.trim(),
        },
      ),
    );

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
      _successMessage = strings.signedInSuccessfully;
      appLogger.i(
        formatLogMessage(
          'auth.login.succeeded',
          details: <String, Object?>{
            'userId': _user?.userId,
            'userName': _user?.userName,
            'elapsedMs': stopwatch.elapsedMilliseconds,
          },
        ),
      );
    } on AppException catch (error) {
      _errorMessage = error.message;
      appLogger.e(
        formatLogMessage(
          'auth.login.failed',
          message: error.message,
        ),
        error: error,
        stackTrace: StackTrace.current,
      );
      rethrow;
    } catch (_) {
      _errorMessage = strings.unableToSignIn;
      appLogger.e(
        formatLogMessage(
          'auth.login.failed',
          message: strings.unableToSignIn,
        ),
        error: _errorMessage,
        stackTrace: StackTrace.current,
      );
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> logout() async {
    appLogger.i(
      formatLogMessage(
        'auth.logout',
        details: <String, Object?>{
          'userId': _user?.userId,
          'userName': _user?.userName,
        },
      ),
    );
    _tokens = null;
    _user = null;
    _employee = null;
    _shiftToday = null;
    _summary = null;
    _policy = null;
    _attendanceLogs = const [];
    _selectedTabIndex = 0;
    _successMessage = strings.signedOut;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshAll() async {
    if (_tokens == null) return;

    _clearMessages();
    _setBusy(true);
    final stopwatch = Stopwatch()..start();
    appLogger.i(formatLogMessage('attendance.refresh_all.started'));

    try {
      await _bootstrapAuthenticatedState(loadLogs: true);
      appLogger.i(
        formatLogMessage(
          'attendance.refresh_all.succeeded',
          details: <String, Object?>{
            'elapsedMs': stopwatch.elapsedMilliseconds,
          },
        ),
      );
    } on AppException catch (error) {
      _errorMessage = error.message;
      appLogger.e(
        formatLogMessage(
          'attendance.refresh_all.failed',
          message: error.message,
        ),
        error: error,
        stackTrace: StackTrace.current,
      );
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> refreshHistory() async {
    if (_tokens == null) return;

    _clearMessages();
    _setBusy(true);
    final stopwatch = Stopwatch()..start();
    appLogger.i(formatLogMessage('attendance.refresh_history.started'));

    try {
      _attendanceLogs = await _attendanceRepository.getAttendanceLogs(
        accessToken: _tokens!.accessToken,
      );
      appLogger.i(
        formatLogMessage(
          'attendance.refresh_history.succeeded',
          details: <String, Object?>{
            'count': _attendanceLogs.length,
            'elapsedMs': stopwatch.elapsedMilliseconds,
          },
        ),
      );
      notifyListeners();
    } on AppException catch (error) {
      _errorMessage = error.message;
      appLogger.e(
        formatLogMessage(
          'attendance.refresh_history.failed',
          message: error.message,
        ),
        error: error,
        stackTrace: StackTrace.current,
      );
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<List<AttendanceLog>> getAttendanceLogsForMonth(DateTime month) async {
    if (_tokens == null) return const [];

    final firstDay = DateTime(month.year, month.month);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    return _attendanceRepository.getAttendanceLogs(
      accessToken: _tokens!.accessToken,
      dateFrom: _formatDate(firstDay),
      dateTo: _formatDate(lastDay),
      limit: 200,
      page: 1,
    );
  }

  Future<void> checkIn({
    required String address,
    required String notes,
    required String deviceName,
    required String selfiePath,
  }) async {
    if (_tokens == null) return;

    _clearMessages();
    _setBusy(true);
    final stopwatch = Stopwatch()..start();
    appLogger.i(
      formatLogMessage(
        'attendance.check_in.started',
        details: <String, Object?>{
          'deviceName': deviceName.trim().isEmpty ? 'Artisan HR App' : deviceName.trim(),
        },
      ),
    );

    try {
      final selfieFileId = await _attendanceRepository.uploadAttendancePhoto(
        accessToken: _tokens!.accessToken,
        attendanceType: 'check_in',
        filePath: selfiePath,
      );
      await _attendanceRepository.checkIn(
        accessToken: _tokens!.accessToken,
        request: CheckInRequest(
          loggedAt: DateTime.now(),
          address: address.trim().isEmpty ? null : address.trim(),
          notes: notes.trim().isEmpty ? null : notes.trim(),
          deviceId: defaultTargetPlatform.name,
          deviceName: deviceName.trim().isEmpty
              ? 'Artisan HR App'
              : deviceName.trim(),
          selfieFileId: selfieFileId,
        ),
      );
      _successMessage = strings.checkInSuccess;
      await _bootstrapAuthenticatedState(loadLogs: true);
      appLogger.i(
        formatLogMessage(
          'attendance.check_in.succeeded',
          details: <String, Object?>{
            'elapsedMs': stopwatch.elapsedMilliseconds,
          },
        ),
      );
    } on AppException catch (error) {
      _errorMessage = error.message;
      appLogger.e(
        formatLogMessage(
          'attendance.check_in.failed',
          message: error.message,
        ),
        error: error,
        stackTrace: StackTrace.current,
      );
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> checkOut({
    required String deviceName,
    required String selfiePath,
  }) async {
    if (_tokens == null) return;

    _clearMessages();
    _setBusy(true);
    final stopwatch = Stopwatch()..start();
    appLogger.i(
      formatLogMessage(
        'attendance.check_out.started',
        details: <String, Object?>{
          'deviceName': deviceName.trim().isEmpty ? 'Artisan HR App' : deviceName.trim(),
        },
      ),
    );

    try {
      final selfieFileId = await _attendanceRepository.uploadAttendancePhoto(
        accessToken: _tokens!.accessToken,
        attendanceType: 'check_out',
        filePath: selfiePath,
      );
      await _attendanceRepository.checkOut(
        accessToken: _tokens!.accessToken,
        request: CheckOutRequest(
          loggedAt: DateTime.now(),
          deviceId: defaultTargetPlatform.name,
          deviceName: deviceName.trim().isEmpty
              ? 'Artisan HR App'
              : deviceName.trim(),
          selfieFileId: selfieFileId,
        ),
      );
      _successMessage = strings.checkOutSuccess;
      await _bootstrapAuthenticatedState(loadLogs: true);
      appLogger.i(
        formatLogMessage(
          'attendance.check_out.succeeded',
          details: <String, Object?>{
            'elapsedMs': stopwatch.elapsedMilliseconds,
          },
        ),
      );
    } on AppException catch (error) {
      _errorMessage = error.message;
      appLogger.e(
        formatLogMessage(
          'attendance.check_out.failed',
          message: error.message,
        ),
        error: error,
        stackTrace: StackTrace.current,
      );
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
    appLogger.i(
      formatLogMessage(
        'navigation.tab_changed',
        details: <String, Object?>{
          'index': index,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> _bootstrapAuthenticatedState({bool loadLogs = true}) async {
    final accessToken = _tokens?.accessToken;
    if (accessToken == null) return;
    final stopwatch = Stopwatch()..start();
    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.started',
        details: <String, Object?>{
          'loadLogs': loadLogs,
        },
      ),
    );
    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.step.started',
        details: const <String, Object?>{'step': 'getMe'},
      ),
    );
    final user = await _authRepository.getMe(accessToken: accessToken);
    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.step.succeeded',
        details: const <String, Object?>{'step': 'getMe'},
      ),
    );

    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.step.started',
        details: const <String, Object?>{'step': 'getEmployeeProfile'},
      ),
    );
    final employee = await _attendanceRepository.getEmployeeProfile(
      accessToken: accessToken,
    );
    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.step.succeeded',
        details: const <String, Object?>{'step': 'getEmployeeProfile'},
      ),
    );

    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.step.started',
        details: const <String, Object?>{'step': 'getAttendanceSummary'},
      ),
    );
    final summary = await _attendanceRepository.getAttendanceSummary(
      accessToken: accessToken,
    );
    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.step.succeeded',
        details: const <String, Object?>{'step': 'getAttendanceSummary'},
      ),
    );

    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.step.started',
        details: const <String, Object?>{'step': 'getAttendancePolicy'},
      ),
    );
    final policy = await _attendanceRepository.getAttendancePolicy(
      accessToken: accessToken,
    );
    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.step.succeeded',
        details: const <String, Object?>{'step': 'getAttendancePolicy'},
      ),
    );

    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.step.started',
        details: const <String, Object?>{'step': 'getShiftToday'},
      ),
    );
    final shiftToday = await _attendanceRepository.getShiftToday(
      accessToken: accessToken,
    );
    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.step.succeeded',
        details: const <String, Object?>{'step': 'getShiftToday'},
      ),
    );

    List<AttendanceLog> attendanceLogs = _attendanceLogs;
    if (loadLogs) {
      appLogger.i(
        formatLogMessage(
          'bootstrap.authenticated.step.started',
          details: const <String, Object?>{'step': 'getAttendanceLogs'},
        ),
      );
      attendanceLogs = await _attendanceRepository.getAttendanceLogs(
        accessToken: accessToken,
      );
      appLogger.i(
        formatLogMessage(
          'bootstrap.authenticated.step.succeeded',
          details: const <String, Object?>{'step': 'getAttendanceLogs'},
        ),
      );
    }

    _user = user;
    _employee = employee;
    _summary = summary;
    _policy = policy;
    _shiftToday = shiftToday;
    _attendanceLogs = List<AttendanceLog>.from(attendanceLogs);
    appLogger.i(
      formatLogMessage(
        'bootstrap.authenticated.succeeded',
        details: <String, Object?>{
          'hasUser': _user != null,
          'hasEmployee': _employee != null,
          'logs': _attendanceLogs.length,
          'elapsedMs': stopwatch.elapsedMilliseconds,
        },
      ),
    );
    notifyListeners();
  }

  void _configureBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    _apiClient = ApiClient(baseUrl: baseUrl);
    _authRepository = AuthRepository(apiClient: _apiClient);
    _attendanceRepository = AttendanceRepository(apiClient: _apiClient);
    appLogger.i(
      formatLogMessage(
        'api.base_url.configured',
        details: <String, Object?>{
          'baseUrl': _baseUrl,
        },
      ),
    );
  }

  String _normalizeBaseUrl(String baseUrl) {
    final trimmed = baseUrl.trim();
    if (trimmed.isEmpty) {
      throw const AppException('API base URL is required.');
    }
    return trimmed.endsWith('/')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
  }

  void _setBusy(bool value) {
    _isBusy = value;
    appLogger.i(
      formatLogMessage(
        'ui.busy_changed',
        details: <String, Object?>{
          'isBusy': value,
        },
      ),
    );
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  String _formatDate(DateTime value) {
    final local = value.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }
}
