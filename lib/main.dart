import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:artisan_hr/app/app.dart';
import 'package:artisan_hr/shared/core/logging/app_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  appLogger.i(
    formatLogMessage(
      'app.start',
      message: 'Application bootstrap started.',
    ),
  );
  FlutterError.onError = (details) {
    appLogger.e(
      formatLogMessage(
        'flutter.error',
        message: details.summary.toDescription(),
        details: <String, Object?>{
          'library': details.library,
          'context': details.context?.toDescription(),
        },
      ),
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    appLogger.e(
      formatLogMessage(
        'platform.error',
        message: 'Unhandled platform error.',
      ),
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  };
  runApp(const ArtisanHrApp());
  appLogger.i(
    formatLogMessage(
      'app.run',
      message: 'Root widget attached.',
    ),
  );
}
