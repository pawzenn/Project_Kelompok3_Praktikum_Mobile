class ResponseRaw {
  final int statusCode;
  final String body;
  final int durationMs;
  final Map<String, List<String>> headers;

  const ResponseRaw({
    required this.statusCode,
    required this.body,
    required this.durationMs,
    required this.headers,
  });
}
