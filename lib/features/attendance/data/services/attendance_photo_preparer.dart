import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

import 'package:artisan_hr/features/attendance/data/models/prepared_upload_file.dart';

class AttendancePhotoPreparer {
  const AttendancePhotoPreparer();

  static const int _targetQuality = 72;
  static const int _targetDimension = 1280;
  static const String _targetContentType = 'image/jpeg';

  Future<PreparedUploadFile> prepareForUpload(String sourcePath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      return const PreparedUploadFile(
        path: '',
        contentType: 'image/jpeg',
        didCompress: false,
      );
    }

    final sourceLength = await sourceFile.length();
    final normalizedExtension = path.extension(sourcePath).toLowerCase();
    final targetPath = path.join(
      sourceFile.parent.path,
      '${path.basenameWithoutExtension(sourcePath)}-upload.jpg',
    );

    // Resize and recompress before upload so the S3 PUT payload stays smaller.
    // Keep EXIF metadata when the platform plugin supports carrying it over.
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      quality: _targetQuality,
      minWidth: _targetDimension,
      minHeight: _targetDimension,
      format: CompressFormat.jpeg,
      keepExif: true,
    );

    if (compressedFile == null) {
      return PreparedUploadFile(
        path: sourcePath,
        contentType: _guessContentType(normalizedExtension),
        didCompress: false,
      );
    }

    final preparedPath = compressedFile.path;
    final preparedLength = await File(preparedPath).length();
    if (preparedLength >= sourceLength) {
      try {
        await File(preparedPath).delete();
      } catch (_) {
        // Ignore cleanup failures and keep the upload flow running.
      }

      return PreparedUploadFile(
        path: sourcePath,
        contentType: _guessContentType(normalizedExtension),
        didCompress: false,
      );
    }

    return PreparedUploadFile(
      path: preparedPath,
      contentType: _targetContentType,
      didCompress: true,
    );
  }

  String _guessContentType(String normalizedExtension) {
    switch (normalizedExtension) {
      case '.png':
        return 'image/png';
      case '.heic':
      case '.heif':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }
}
