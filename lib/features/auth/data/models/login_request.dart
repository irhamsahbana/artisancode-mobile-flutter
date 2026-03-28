class LoginRequest {
  const LoginRequest({
    required this.email,
    required this.password,
    required this.tenantCode,
  });

  final String email;
  final String password;
  final String tenantCode;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'tenant_code': tenantCode,
    };
  }
}
