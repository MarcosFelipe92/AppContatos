import 'package:app_contatos/app/models/contact.dart';
import 'package:app_contatos/app/repositories/contact_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../controllers/contact_controller_test.dart';

void main() {
  late ContactRepository repository;

  setUp(() {
    repository = MockContactRepository();
  });

  group("FindAll", () {
    test("Deve retornar uma lista de contatos", () async {
      final mockContacts = [
        Contact(
            id: 1,
            name: 'Alice',
            email: 'alice@example.com',
            phone: '123456789'),
        Contact(
            id: 2, name: 'Bob', email: 'bob@example.com', phone: '987654321'),
      ];

      when(() => repository.findAll()).thenAnswer((_) async => mockContacts);

      final result = await repository.findAll();

      expect(result, equals(mockContacts));
      expect(result.length, 2);
      expect(result[0].name, equals("Alice"));

      verify(() => repository.findAll()).called(1);
    });
  });
}
