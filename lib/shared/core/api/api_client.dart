import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:artisan_hr/shared/core/api/api_response.dart';
import 'package:artisan_hr/shared/core/errors/app_exception.dart';
import 'package:artisan_hr/shared/core/logging/app_logger.dart';

class ApiRequestCancellationToken {
  bool _isCancelled = false;
  final List<void Function()> _listeners = <void Function()>[];

  bool get isCancelled => _isCancelled;

  void cancel() {
    if (_isCancelled) {
      return;
    }
    _isCancelled = true;
    final listeners = List<void Function()>.from(_listeners);
    _listeners.clear();
    for (final listener in listeners) {
      listener();
    }
  }

  void Function() addListener(void Function() listener) {
    if (_isCancelled) {
      listener();
      return () {};
    }
    _listeners.add(listener);
    return () {
      _listeners.remove(listener);
    };
  }
}

class ApiRequestCancelledException implements Exception {
  const ApiRequestCancelledException();
}

class ApiClient {
  ApiClient({required String baseUrl, String languageCode = 'id'})
    : _baseUrl = baseUrl,
      _languageCode = languageCode == 'en' ? 'en' : 'id' {
    _httpClient.connectionTimeout = _connectionTimeout;
  }

  final String _baseUrl;
  final HttpClient _httpClient = HttpClient();
  String _languageCode;
  static const Duration _connectionTimeout = Duration(seconds: 10);
  static const Duration _requestTimeout = Duration(seconds: 20);

  void setLanguageCode(String languageCode) {
    _languageCode = languageCode == 'en' ? 'en' : 'id';
  }

  Future<ApiResponse> get(
    String path, {
    String? accessToken,
    Map<String, String?>? queryParameters,
    ApiRequestCancellationToken? cancellationToken,
  }) {
    return _send(
      method: 'GET',
      path: path,
      accessToken: accessToken,
      queryParameters: queryParameters,
      cancellationToken: cancellationToken,
    );
  }

  Future<ApiResponse> post(
    String path, {
    String? accessToken,
    Map<String, dynamic>? body,
  }) {
    return _send(
      method: 'POST',
      path: path,
      accessToken: accessToken,
      body: body,
    );
  }

  Future<void> putBinary(
    String url, {
    required List<int> body,
    required String contentType,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);
    final stopwatch = Stopwatch()..start();
    appLogger.i(
      formatLogMessage(
        'api.upload.started',
        details: <String, Object?>{
          'url': uri.toString(),
          'contentType': contentType,
          'bytes': body.length,
        },
      ),
    );
    try {
      final request = await _httpClient
          .openUrl('PUT', uri)
          .timeout(_connectionTimeout);
      request.headers.contentType = ContentType.parse(contentType);
      headers?.forEach((key, value) {
        if (value.isNotEmpty) {
          if (key.toLowerCase() == HttpHeaders.contentLengthHeader) {
            return;
          }
          request.headers.set(key, value);
        }
      });
      request.contentLength = body.length;
      request.add(body);

      final response = await request.close().timeout(_requestTimeout);
      final responseBody = await response
          .transform(utf8.decoder)
          .join()
          .timeout(_requestTimeout);
      if (response.statusCode >= 400) {
        throw AppException(
          responseBody.isEmpty
              ? 'Upload failed with status ${response.statusCode}.'
              : responseBody,
        );
      }
      appLogger.i(
        formatLogMessage(
          'api.upload.succeeded',
          details: <String, Object?>{
            'statusCode': response.statusCode,
            'url': uri.toString(),
            'elapsedMs': stopwatch.elapsedMilliseconds,
          },
        ),
      );
    } on SocketException {
      appLogger.e(
        formatLogMessage(
          'api.upload.failed',
          message: 'Unable to upload the photo proof right now.',
          details: <String, Object?>{'url': uri.toString()},
        ),
        error: 'socket_exception',
        stackTrace: StackTrace.current,
      );
      throw const AppException('Unable to upload the photo proof right now.');
    } on TimeoutException {
      appLogger.e(
        formatLogMessage(
          'api.upload.failed',
          message: 'The photo proof upload timed out.',
          details: <String, Object?>{'url': uri.toString()},
        ),
        error: 'timeout_exception',
        stackTrace: StackTrace.current,
      );
      throw const AppException('The photo proof upload timed out.');
    }
  }

  Future<ApiResponse> _send({
    required String method,
    required String path,
    String? accessToken,
    Map<String, dynamic>? body,
    Map<String, String?>? queryParameters,
    ApiRequestCancellationToken? cancellationToken,
  }) async {
    final baseUri = Uri.parse('$_baseUrl$path');
    final sanitizedQueryParameters = queryParameters == null
        ? null
        : Map<String, String>.fromEntries(
            queryParameters.entries
                .where(
                  (entry) =>
                      entry.value != null && entry.value!.trim().isNotEmpty,
                )
                .map((entry) => MapEntry(entry.key, entry.value!.trim())),
          );
    final uri =
        sanitizedQueryParameters == null || sanitizedQueryParameters.isEmpty
        ? baseUri
        : baseUri.replace(queryParameters: sanitizedQueryParameters);
    final stopwatch = Stopwatch()..start();
    appLogger.i(
      formatLogMessage(
        'api.request.started',
        details: <String, Object?>{
          'method': method,
          'url': uri.toString(),
          'hasBody': body != null,
        },
      ),
    );
    void Function()? removeCancellationListener;

    try {
      if (cancellationToken?.isCancelled ?? false) {
        throw const ApiRequestCancelledException();
      }

      final request = await _httpClient
          .openUrl(method, uri)
          .timeout(_connectionTimeout);
      if (cancellationToken?.isCancelled ?? false) {
        request.abort(const ApiRequestCancelledException());
        throw const ApiRequestCancelledException();
      }
      removeCancellationListener = cancellationToken?.addListener(() {
        request.abort(const ApiRequestCancelledException());
      });
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.acceptLanguageHeader, _languageCode);
      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers.set(
          HttpHeaders.authorizationHeader,
          'Bearer $accessToken',
        );
      }
      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close().timeout(_requestTimeout);
      final responseBody = await response
          .transform(utf8.decoder)
          .join()
          .timeout(_requestTimeout);
      final json = responseBody.isEmpty
          ? const <String, dynamic>{}
          : jsonDecode(responseBody) as Map<String, dynamic>;

      final apiResponse = ApiResponse.fromJson(
        statusCode: response.statusCode,
        json: json,
      );

      if (response.statusCode >= 400 || !apiResponse.success) {
        throw AppException(
          apiResponse.message.isEmpty
              ? 'Request failed with status ${response.statusCode}.'
              : apiResponse.message,
        );
      }

      appLogger.i(
        formatLogMessage(
          'api.request.succeeded',
          details: <String, Object?>{
            'method': method,
            'url': uri.toString(),
            'statusCode': response.statusCode,
            'elapsedMs': stopwatch.elapsedMilliseconds,
          },
        ),
      );
      return apiResponse;
    } on ApiRequestCancelledException {
      appLogger.i(
        formatLogMessage(
          'api.request.cancelled',
          details: <String, Object?>{'method': method, 'url': uri.toString()},
        ),
      );
      rethrow;
    } on SocketException {
      if (cancellationToken?.isCancelled ?? false) {
        appLogger.i(
          formatLogMessage(
            'api.request.cancelled',
            details: <String, Object?>{'method': method, 'url': uri.toString()},
          ),
        );
        throw const ApiRequestCancelledException();
      }
      appLogger.e(
        formatLogMessage(
          'api.request.failed',
          message: 'Unable to connect to the API.',
          details: <String, Object?>{'method': method, 'url': uri.toString()},
        ),
        error: 'socket_exception',
        stackTrace: StackTrace.current,
      );
      throw const AppException(
        'Unable to connect to the API. Check the base URL and your network access.',
      );
    } on TimeoutException {
      if (cancellationToken?.isCancelled ?? false) {
        appLogger.i(
          formatLogMessage(
            'api.request.cancelled',
            details: <String, Object?>{'method': method, 'url': uri.toString()},
          ),
        );
        throw const ApiRequestCancelledException();
      }
      appLogger.e(
        formatLogMessage(
          'api.request.failed',
          message: 'The request timed out.',
          details: <String, Object?>{'method': method, 'url': uri.toString()},
        ),
        error: 'timeout_exception',
        stackTrace: StackTrace.current,
      );
      throw const AppException('The request timed out.');
    } on FormatException {
      appLogger.e(
        formatLogMessage(
          'api.request.failed',
          message: 'The server returned an unexpected response format.',
          details: <String, Object?>{'method': method, 'url': uri.toString()},
        ),
        error: 'format_exception',
        stackTrace: StackTrace.current,
      );
      throw const AppException(
        'The server returned an unexpected response format.',
      );
    } on AppException catch (error) {
      appLogger.e(
        formatLogMessage(
          'api.request.failed',
          message: error.message,
          details: <String, Object?>{'method': method, 'url': uri.toString()},
        ),
        error: error,
        stackTrace: StackTrace.current,
      );
      rethrow;
    } finally {
      removeCancellationListener?.call();
    }
  }
}
