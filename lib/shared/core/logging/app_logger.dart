import 'package:logger/logger.dart';

final Logger appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 120,
    colors: false,
    printEmojis: false,
  ),
);

String formatLogMessage(
  String event, {
  String? message,
  Map<String, Object?> details = const <String, Object?>{},
}) {
  final buffer = StringBuffer(event);
  if (message != null && message.trim().isNotEmpty) {
    buffer.write(' | ${message.trim()}');
  }
  if (details.isNotEmpty) {
    buffer.write(' | ');
    buffer.write(
      details.entries.map((entry) => '${entry.key}=${entry.value}').join(', '),
    );
  }
  return buffer.toString();
}
