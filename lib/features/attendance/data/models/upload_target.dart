class UploadTarget {
  const UploadTarget({
    required this.fileId,
    required this.objectKey,
    required this.uploadUrl,
    required this.method,
    required this.headers,
  });

  final String fileId;
  final String objectKey;
  final String uploadUrl;
  final String method;
  final Map<String, String> headers;

  factory UploadTarget.fromJson(Map<String, dynamic> json) {
    final rawHeaders = json['headers'];
    return UploadTarget(
      fileId: json['file_id'] as String? ?? '',
      objectKey: json['object_key'] as String? ?? '',
      uploadUrl: json['upload_url'] as String? ?? '',
      method: json['method'] as String? ?? 'PUT',
      headers: rawHeaders is Map
          ? rawHeaders.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : const {},
    );
  }
}
