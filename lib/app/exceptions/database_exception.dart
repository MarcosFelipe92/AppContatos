class DatabaseException implements Exception {
  final String message;

  DatabaseException({required this.message});

  @override
  String toString() => message;
}
