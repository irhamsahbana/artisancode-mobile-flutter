class UserContext {
  const UserContext({
    required this.userId,
    required this.userName,
    required this.tenantId,
    required this.tenantName,
    required this.roles,
  });

  final String userId;
  final String userName;
  final String tenantId;
  final String tenantName;
  final List<String> roles;

  factory UserContext.fromJson(Map<String, dynamic> json) {
    final roleValues = json['roles'];
    return UserContext(
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      tenantId: json['tenant_id'] as String? ?? '',
      tenantName: json['tenant_name'] as String? ?? '',
      roles: roleValues is List
          ? roleValues.map((item) => item.toString()).toList(growable: false)
          : const [],
    );
  }
}
