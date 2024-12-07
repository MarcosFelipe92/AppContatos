import 'package:app_contatos/app/controllers/contact_controller.dart';
import 'package:app_contatos/app/exceptions/contact_not_found_exception.dart';
import 'package:app_contatos/app/exceptions/database_exception.dart';
import 'package:app_contatos/app/exceptions/exist_email_exception.dart';
import 'package:app_contatos/app/exceptions/invalid_contact_exceptions.dart';
import 'package:app_contatos/app/models/contact.dart';
import 'package:app_contatos/app/repositories/contact_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactRepository extends Mock implements ContactRepository {}

void main() {
  const int contactId = 1;
  const String contactName = 'Alice';
  const String contactEmail = 'alice@example.com';
  const String contactPhone = '123456789';

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
            id: contactId,
            name: contactName,
            email: contactEmail,
            phone: contactPhone)
      ];

      when(() => repository.findAll()).thenAnswer((_) async => mockContacts);

      final result = await controller.findAll();

      expect(result, equals(mockContacts));
      expect(result.length, 1);
      expect(result[0].name, equals(contactName));

      verify(() => repository.findAll()).called(1);
    });

    test(
        "Deve lançar DatabaseException quando ocorrer um erro ao buscar todos os contatos",
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
          id: contactId,
          name: contactName,
          email: contactEmail,
          phone: contactPhone);

      when(() => repository.findById(contactId))
          .thenAnswer((_) async => mockContact);

      final result = await controller.findById(contactId);

      expect(result, equals(mockContact));
      expect(result.id, contactId);

      verify(() => repository.findById(contactId)).called(1);
    });

    test(
        "Deve lançar ContactNotFoundException quando não houver contato para o ID fornecido",
        () async {
      when(() => repository.findById(contactId)).thenAnswer((_) async => null);

      expect(() => controller.findById(contactId),
          throwsA(isA<ContactNotFoundException>()));

      verify(() => repository.findById(contactId)).called(1);
    });

    test(
        "Deve lançar DatabaseException quando ocorrer um erro ao buscar um contato por ID",
        () async {
      when(() => repository.findById(contactId))
          .thenAnswer((_) async => throw Exception());

      expect(() => controller.findById(contactId),
          throwsA(isA<DatabaseException>()));

      verify(() => repository.findById(contactId)).called(1);
    });
  });

  group("Create", () {
    test(
        "Deve adicionar um contato ao banco, quando um contato válido for fornecido",
        () async {
      final mockContact =
          Contact(name: contactName, email: contactEmail, phone: contactPhone);

      when(() => repository.existsByEmail(contactEmail))
          .thenAnswer((_) async => false);

      when(() => repository.create(mockContact)).thenAnswer((_) async {});

      await controller.create(mockContact);

      expect(controller.contacts, contains(mockContact));
      verify(() => repository.existsByEmail(contactEmail)).called(1);
      verify(() => repository.create(mockContact)).called(1);
    });

    test(
        "Deve lançar InvalidContactException quando fornecido um contato invalido",
        () async {
      final mockContact = Contact(name: "", email: "", phone: "");

      expect(() => controller.create(mockContact),
          throwsA(isA<InvalidContactException>()));

      verifyNever(() => repository.existsByEmail(contactEmail));
      verifyNever(() => repository.create(mockContact));
    });

    test("Deve lançar ExistEmailException quando o email fornecido já existir",
        () async {
      final mockContact =
          Contact(name: contactName, email: contactEmail, phone: contactPhone);

      when(() => repository.existsByEmail(contactEmail))
          .thenAnswer((_) async => true);

      expect(() => controller.create(mockContact),
          throwsA(isA<ExistEmailException>()));

      verify(() => repository.existsByEmail(contactEmail)).called(1);
      verifyNever(() => repository.create(mockContact));
    });

    test(
        "Deve lançar DatabaseException quando ocorrer um erro ao criar um contato",
        () async {
      final mockContact =
          Contact(name: contactName, email: contactEmail, phone: contactPhone);

      when(() => repository.existsByEmail(contactEmail))
          .thenAnswer((_) async => false);

      when(() => repository.create(mockContact))
          .thenAnswer((_) async => throw Exception());

      await expectLater(() => controller.create(mockContact),
          throwsA(isA<DatabaseException>()));

      verify(() => repository.create(mockContact)).called(1);
    });
  });

  group("Update", () {
    test(
        "Deve alterar o contato com sucesso quando fornecido um contato válido",
        () async {
      final mockContact = Contact(
          id: contactId,
          name: contactName,
          email: contactEmail,
          phone: contactPhone);

      when(() => repository.findById(contactId))
          .thenAnswer((_) async => mockContact);

      when(() => repository.update(mockContact)).thenAnswer((_) async {});

      await controller.update(mockContact);

      verify(() => repository.findById(contactId)).called(1);
      verify(() => repository.update(mockContact)).called(1);
    });

    test("Deve lançar InvalidContactException ao fornecer um contato inválido",
        () async {
      final mockContact = Contact(name: "", email: "", phone: "");

      expect(() => controller.update(mockContact),
          throwsA(isA<InvalidContactException>()));

      verifyNever(() => repository.findById(contactId));
      verifyNever(() => repository.update(mockContact));
    });

    test(
        "Deve lançar ContactNotFoundException quando não houver contato para o ID fornecido",
        () async {
      final mockContact = Contact(
          id: contactId,
          name: contactName,
          email: contactEmail,
          phone: contactPhone);

      when(() => repository.findById(contactId)).thenAnswer((_) async => null);

      expect(() => controller.update(mockContact),
          throwsA(isA<ContactNotFoundException>()));

      verify(() => repository.findById(contactId)).called(1);
      verifyNever(() => repository.update(mockContact));
    });

    test(
        "Deve lançar DatabaseException quando ocorrer um erro ao alterar um contato",
        () async {
      final mockContact = Contact(
          id: contactId,
          name: contactName,
          email: contactEmail,
          phone: contactPhone);

      when(() => repository.findById(contactId))
          .thenAnswer((_) async => mockContact);

      when(() => repository.update(mockContact))
          .thenAnswer((_) async => throw Exception());

      await expectLater(() => controller.update(mockContact),
          throwsA(isA<DatabaseException>()));

      verify(() => repository.findById(contactId)).called(1);
      verify(() => repository.update(mockContact)).called(1);
    });
  });

  group("Delete", () {
    test("Deve deletar o contato quando um ID válido for fornecido", () async {
      final mockContact = Contact(
          id: contactId,
          name: contactName,
          email: contactEmail,
          phone: contactPhone);

      controller.contacts.add(mockContact);

      when(() => repository.findById(contactId))
          .thenAnswer((_) async => mockContact);
      when(() => repository.delete(contactId)).thenAnswer((_) async {});

      await controller.delete(contactId);

      expect(controller.contacts, isNot(contains(mockContact)));
      verify(() => repository.findById(contactId)).called(1);
      verify(() => repository.delete(contactId)).called(1);
    });

    test(
      "Deve lançar ContactNotFoundException quando não houver contato para o ID fornecido",
      () async {
        when(() => repository.findById(contactId))
            .thenAnswer((_) async => null);

        expect(
          () => controller.delete(contactId),
          throwsA(isA<ContactNotFoundException>()),
        );

        verify(() => repository.findById(contactId)).called(1);

        verifyNever(() => repository.delete(contactId));
      },
    );

    test(
      "Deve lançar DatabaseException quando ocorrer um erro ao deletar um contato",
      () async {
        final mockContact = Contact(
            id: contactId,
            name: contactName,
            email: contactEmail,
            phone: contactPhone);

        when(() => repository.findById(contactId))
            .thenAnswer((_) async => mockContact);

        when(() => repository.delete(contactId))
            .thenAnswer((_) async => throw Exception());

        await expectLater(
          () => controller.delete(contactId),
          throwsA(isA<DatabaseException>()),
        );

        verify(() => repository.delete(contactId)).called(1);
        verify(() => repository.findById(contactId)).called(1);
      },
    );
  });
}
