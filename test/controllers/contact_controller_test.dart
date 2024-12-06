import 'package:app_contatos/app/controllers/contact_controller.dart';
import 'package:app_contatos/app/exceptions/contact_not_found_exception.dart';
import 'package:app_contatos/app/exceptions/database_exception.dart';
import 'package:app_contatos/app/models/contact.dart';
import 'package:app_contatos/app/repositories/contact_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactRepository extends Mock implements ContactRepository {}

void main() {
  const int contact_id = 1;
  const String contact_name = 'Alice';
  const String contact_email = 'alice@example.com';
  const String contact_phone = '123456789';

  late ContactRepository repository;
  late ContactController controller;

  setUp(() {
    repository = MockContactRepository();
    controller = ContactController(repository);
  });

  group("FindAll", () {
    test("Deve retornar uma lista de contatos quando a busca for bem-sucedida",
        () async {
      final mockContacts = [
        Contact(
            id: contact_id,
            name: contact_name,
            email: contact_email,
            phone: contact_phone)
      ];

      when(() => repository.findAll()).thenAnswer((_) async => mockContacts);

      final result = await controller.findAll();

      expect(result, equals(mockContacts));
      expect(result.length, 1);
      expect(result[0].name, equals(contact_name));

      verify(() => repository.findAll()).called(1);
    });

    test(
        "Deve lançar uma DatabaseException quando ocorrer um erro ao buscar todos os contatos",
        () async {
      when(() => repository.findAll())
          .thenAnswer((_) async => throw Exception());

      expect(() => controller.findAll(), throwsA(isA<DatabaseException>()));

      verify(() => repository.findAll()).called(1);
    });
  });

  group("FindById", () {
    test("Deve retornar o contato correto quando um ID válido for fornecido",
        () async {
      final mockContact = Contact(
          id: contact_id,
          name: contact_name,
          email: contact_email,
          phone: contact_phone);

      when(() => repository.findById(contact_id))
          .thenAnswer((_) async => mockContact);

      final result = await controller.findById(contact_id);

      expect(result, equals(mockContact));
      expect(result.id, contact_id);

      verify(() => repository.findById(contact_id)).called(1);
    });

    test(
        "Deve lançar uma ContactNotFoundException quando não houver contato para o ID fornecido",
        () async {
      when(() => repository.findById(contact_id)).thenAnswer((_) async => null);

      expect(() => controller.findById(contact_id),
          throwsA(isA<ContactNotFoundException>()));

      verify(() => repository.findById(contact_id)).called(1);
    });

    test(
        "Deve lançar uma DatabaseException quando ocorrer um erro ao buscar um contato por ID",
        () async {
      when(() => repository.findById(contact_id))
          .thenAnswer((_) async => throw Exception());

      expect(() => controller.findById(contact_id),
          throwsA(isA<DatabaseException>()));

      verify(() => repository.findById(contact_id)).called(1);
    });
  });

  group("Delete", () {
    test("Deve deletar o contato quando um ID válido for fornecido", () async {
      final mockContact = Contact(
          id: contact_id,
          name: contact_name,
          email: contact_email,
          phone: contact_phone);

      when(() => repository.findById(contact_id))
          .thenAnswer((_) async => mockContact);
      when(() => repository.delete(contact_id)).thenAnswer((_) async {});

      await controller.delete(contact_id);

      verify(() => repository.findById(contact_id)).called(1);
      verify(() => repository.delete(contact_id)).called(1);
    });

    test(
      "Deve lançar uma ContactNotFoundException quando não houver contato para o ID fornecido",
      () async {
        when(() => repository.findById(contact_id))
            .thenAnswer((_) async => null);

        expect(
          () => controller.delete(contact_id),
          throwsA(isA<ContactNotFoundException>()),
        );

        verify(() => repository.findById(contact_id)).called(1);

        verifyNever(() => repository.delete(contact_id));
      },
    );

    test(
      "Deve lançar uma DatabaseException quando ocorrer um erro ao deletar um contato",
      () async {
        final mockContact = Contact(
            id: contact_id,
            name: contact_name,
            email: contact_email,
            phone: contact_phone);

        when(() => repository.findById(contact_id))
            .thenAnswer((_) async => mockContact);

        when(() => repository.delete(contact_id))
            .thenAnswer((_) async => throw Exception());

        await expectLater(
          () => controller.delete(contact_id),
          throwsA(isA<DatabaseException>()),
        );

        verify(() => repository.delete(contact_id)).called(1);
        verify(() => repository.findById(contact_id)).called(1);
      },
    );
  });
}
