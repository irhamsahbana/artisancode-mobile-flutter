class CheckOutRequest {
  const CheckOutRequest({
    required this.loggedAt,
    required this.deviceId,
    required this.deviceName,
    required this.selfieFileId,
  });

  final DateTime loggedAt;
  final String deviceId;
  final String deviceName;
  final String selfieFileId;

  Map<String, dynamic> toJson() {
    return {
      'logged_at': loggedAt.toIso8601String(),
      'device_id': deviceId,
      'device_name': deviceName,
      'selfie_file_id': selfieFileId,
    };
  }
}
