class CheckInRequest {
  const CheckInRequest({
    required this.loggedAt,
    required this.deviceId,
    required this.deviceName,
    required this.selfieFileId,
    this.address,
    this.notes,
    this.latitude,
    this.longitude,
  });

  final DateTime loggedAt;
  final String deviceId;
  final String deviceName;
  final String selfieFileId;
  final String? address;
  final String? notes;
  final double? latitude;
  final double? longitude;

  Map<String, dynamic> toJson() {
    return {
      'logged_at': loggedAt.toIso8601String(),
      'device_id': deviceId,
      'device_name': deviceName,
      'selfie_file_id': selfieFileId,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }
}
