import 'package:artisan_hr/features/auth/data/models/auth_tokens.dart';
import 'package:artisan_hr/features/auth/data/models/login_request.dart';
import 'package:artisan_hr/features/auth/data/models/user_context.dart';
import 'package:artisan_hr/shared/core/api/api_client.dart';

class AuthRepository {
  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<AuthTokens> login(LoginRequest request) async {
    final response = await _apiClient.post(
      '/users/login',
      body: request.toJson(),
    );

    return AuthTokens.fromJson(response.requireDataMap());
  }

  Future<UserContext> getMe({required String accessToken}) async {
    final response = await _apiClient.get('/me', accessToken: accessToken);

    return UserContext.fromJson(response.requireDataMap());
  }
}
