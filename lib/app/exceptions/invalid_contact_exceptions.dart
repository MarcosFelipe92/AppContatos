class InvalidContactException implements Exception {
  final String message;

  InvalidContactException({required this.message});

  @override
  String toString() => message;
}
