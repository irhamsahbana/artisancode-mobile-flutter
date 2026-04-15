import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../errors/app_exception.dart';
import '../logging/app_logger.dart';
import 'api_response.dart';

class ApiClient {
  ApiClient({required String baseUrl}) : _baseUrl = baseUrl {
    _httpClient.connectionTimeout = _connectionTimeout;
  }

  final String _baseUrl;
  final HttpClient _httpClient = HttpClient();
  static const Duration _connectionTimeout = Duration(seconds: 10);
  static const Duration _requestTimeout = Duration(seconds: 20);

  Future<ApiResponse> get(
    String path, {
    String? accessToken,
    Map<String, String?>? queryParameters,
  }) {
    return _send(
      method: 'GET',
      path: path,
      accessToken: accessToken,
      queryParameters: queryParameters,
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
        throw AppException(responseBody.isEmpty
            ? 'Upload failed with status ${response.statusCode}.'
            : responseBody);
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
          details: <String, Object?>{
            'url': uri.toString(),
          },
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
          details: <String, Object?>{
            'url': uri.toString(),
          },
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
  }) async {
    final baseUri = Uri.parse('$_baseUrl$path');
    final sanitizedQueryParameters = queryParameters == null
        ? null
        : Map<String, String>.fromEntries(
            queryParameters.entries.where(
              (entry) => entry.value != null && entry.value!.trim().isNotEmpty,
            ).map((entry) => MapEntry(entry.key, entry.value!.trim())),
          );
    final uri = sanitizedQueryParameters == null || sanitizedQueryParameters.isEmpty
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
    try {
      final request = await _httpClient
          .openUrl(method, uri)
          .timeout(_connectionTimeout);
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $accessToken');
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
        throw AppException(apiResponse.message.isEmpty
            ? 'Request failed with status ${response.statusCode}.'
            : apiResponse.message);
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
    } on SocketException {
      appLogger.e(
        formatLogMessage(
          'api.request.failed',
          message: 'Unable to connect to the API.',
          details: <String, Object?>{
            'method': method,
            'url': uri.toString(),
          },
        ),
        error: 'socket_exception',
        stackTrace: StackTrace.current,
      );
      throw const AppException(
        'Unable to connect to the API. Check the base URL and your network access.',
      );
    } on TimeoutException {
      appLogger.e(
        formatLogMessage(
          'api.request.failed',
          message: 'The request timed out.',
          details: <String, Object?>{
            'method': method,
            'url': uri.toString(),
          },
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
          details: <String, Object?>{
            'method': method,
            'url': uri.toString(),
          },
        ),
        error: 'format_exception',
        stackTrace: StackTrace.current,
      );
      throw const AppException('The server returned an unexpected response format.');
    } on AppException catch (error) {
      appLogger.e(
        formatLogMessage(
          'api.request.failed',
          message: error.message,
          details: <String, Object?>{
            'method': method,
            'url': uri.toString(),
          },
        ),
        error: error,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }
}
