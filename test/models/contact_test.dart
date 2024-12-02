import 'package:app_contatos/app/models/contact.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final contact = Contact(
      id: 1, name: "Marcos", email: "marcos@gmail.com", phone: "62993806140");

  group("toMap", () {
    test("deve retornar um Map com os valores do Contato", () {
      Map<String, dynamic> contactMap = contact.toMap();

      expect(
          contactMap,
          equals({
            'id': 1,
            'name': 'Marcos',
            'email': 'marcos@gmail.com',
            'phone': '62993806140'
          }));
    });
  });

  group("fromMap", () {
    test("deve converter o Map para um Contato", () {
      Contact newContact = Contact.fromMap({
        'id': 1,
        'name': 'Marcos',
        'email': 'marcos@gmail.com',
        'phone': '62993806140'
      });

      expect(newContact, equals(contact));
    });
  });
}
