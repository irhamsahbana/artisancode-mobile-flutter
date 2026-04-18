import 'package:artisan_hr/features/attendance/data/models/device_location_snapshot.dart';
import 'package:artisan_hr/shared/core/logging/app_logger.dart';
import 'package:geolocator/geolocator.dart';

class DeviceLocationService {
  const DeviceLocationService();

  Future<DeviceLocationSnapshot?> getCurrentLocation() async {
    try {
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        appLogger.w(
          formatLogMessage(
            'attendance.location.skipped',
            message: 'Location service is disabled.',
          ),
        );
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        appLogger.w(
          formatLogMessage(
            'attendance.location.skipped',
            message: 'Location permission is not granted.',
            details: <String, Object?>{'permission': permission.name},
          ),
        );
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return DeviceLocationSnapshot(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (error, stackTrace) {
      appLogger.w(
        formatLogMessage(
          'attendance.location.failed',
          message: 'Unable to capture current location.',
        ),
        error: error,
        stackTrace: stackTrace,
      );

      try {
        final lastKnownPosition = await Geolocator.getLastKnownPosition();
        if (lastKnownPosition == null) {
          return null;
        }

        return DeviceLocationSnapshot(
          latitude: lastKnownPosition.latitude,
          longitude: lastKnownPosition.longitude,
        );
      } catch (fallbackError, fallbackStackTrace) {
        appLogger.w(
          formatLogMessage(
            'attendance.location.failed',
            message: 'Unable to read last known location.',
          ),
          error: fallbackError,
          stackTrace: fallbackStackTrace,
        );
        return null;
      }
    }
  }
}
