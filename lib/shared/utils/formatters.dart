String formatDateTime(DateTime? value) {
  if (value == null) return '-';

  final local = value.toLocal();
  final date =
      '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  final time =
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  return '$date $time';
}

String formatTimezoneLabel(String? value, String languageCode) {
  final timezone = value?.trim();
  if (timezone == null || timezone.isEmpty || timezone == '-') return '-';

  switch (timezone) {
    case 'Asia/Jakarta':
      return 'WIB (Jakarta)';
    case 'Asia/Makassar':
      return 'WITA (Makassar)';
    case 'Asia/Jayapura':
      return 'WIT (Jayapura)';
    case 'Asia/Singapore':
      return languageCode == 'id'
          ? 'GMT+8 (Singapura)'
          : 'GMT+8 (Singapore)';
    case 'UTC':
      return 'UTC';
    default:
      return timezone;
  }
}
