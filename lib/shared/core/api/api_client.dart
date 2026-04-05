import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../errors/app_exception.dart';
import 'api_response.dart';

class ApiClient {
  ApiClient({required String baseUrl}) : _baseUrl = baseUrl;

  final String _baseUrl;
  final HttpClient _httpClient = HttpClient();

  Future<ApiResponse> get(
    String path, {
    String? accessToken,
  }) {
    return _send(
      method: 'GET',
      path: path,
      accessToken: accessToken,
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
    try {
      final request = await _httpClient.openUrl('PUT', uri);
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

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode >= 400) {
        throw AppException(responseBody.isEmpty
            ? 'Upload failed with status ${response.statusCode}.'
            : responseBody);
      }
    } on SocketException {
      throw const AppException('Unable to upload the photo proof right now.');
    } on TimeoutException {
      throw const AppException('The photo proof upload timed out.');
    }
  }

  Future<ApiResponse> _send({
    required String method,
    required String path,
    String? accessToken,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    try {
      final request = await _httpClient.openUrl(method, uri);
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $accessToken');
      }
      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
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

      return apiResponse;
    } on SocketException {
      throw const AppException(
        'Unable to connect to the API. Check the base URL and your network access.',
      );
    } on TimeoutException {
      throw const AppException('The request timed out.');
    } on FormatException {
      throw const AppException('The server returned an unexpected response format.');
    }
  }
}
