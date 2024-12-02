class ExistEmailException {
  final String message;

  ExistEmailException({required this.message});

  @override
  String toString() => message;
}
