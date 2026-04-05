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
      'logged_at': _toApiDateTime(loggedAt),
      'device_id': deviceId,
      'device_name': deviceName,
      'selfie_file_id': selfieFileId,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  String _toApiDateTime(DateTime value) {
    final local = value.toLocal();
    final offset = local.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final totalMinutes = offset.inMinutes.abs();
    final offsetHours = (totalMinutes ~/ 60).toString().padLeft(2, '0');
    final offsetMinutes = (totalMinutes % 60).toString().padLeft(2, '0');

    String twoDigits(int number) => number.toString().padLeft(2, '0');

    return '${local.year.toString().padLeft(4, '0')}-'
        '${twoDigits(local.month)}-'
        '${twoDigits(local.day)}T'
        '${twoDigits(local.hour)}:'
        '${twoDigits(local.minute)}:'
        '${twoDigits(local.second)}'
        '$sign$offsetHours:$offsetMinutes';
  }
}
