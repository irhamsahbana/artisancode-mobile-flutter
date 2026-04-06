class PreparedUploadFile {
  const PreparedUploadFile({
    required this.path,
    required this.contentType,
    required this.didCompress,
  });

  final String path;
  final String contentType;
  final bool didCompress;
}
