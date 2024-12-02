class ContactNotFoundException implements Exception {
  final String message;

  ContactNotFoundException({required this.message});

  @override
  String toString() => message;
}
