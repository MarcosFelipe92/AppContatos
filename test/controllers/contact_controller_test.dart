import 'package:app_contatos/app/controllers/contact_controller.dart';
import 'package:app_contatos/app/models/contact.dart';
import 'package:app_contatos/app/repositories/contact_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactRepository extends Mock implements ContactRepository {}

void main() {
  late ContactRepository repository;
  late ContactController controller;

  setUp(() {
    repository = MockContactRepository();
    controller = ContactController(repository);
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

      final result = await controller.findAll();

      expect(result, equals(mockContacts));
      expect(result.length, 2);
      expect(result[0].name, equals("Alice"));

      verify(() => repository.findAll()).called(1);
    });
  });
}
