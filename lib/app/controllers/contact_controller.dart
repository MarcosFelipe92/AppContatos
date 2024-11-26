import 'dart:async';

import 'package:app_contatos/app/models/contact.dart';
import 'package:app_contatos/app/repositories/contact_repository.dart';
import 'package:flutter/material.dart';

class ContactController extends ChangeNotifier {
  final ContactRepository _contactRepository;
  bool _isLoading = true;
  List<Contact> _contacts = [];

  ContactController(this._contactRepository);

  List<Contact> get contacts {
    return [..._contacts];
  }

  bool get isLoading => _isLoading;

  int get count {
    return _contacts.length;
  }

  Future<List<Contact>> findAll() async {
    _contacts = await _contactRepository.findAll();
    _isLoading = false;
    return _contacts;
  }

  Contact findById(int id) {
    return _contacts.firstWhere((contact) => contact.id == id,
        orElse: () =>
            Contact(id: -1, name: 'Contato Padrão', email: '', phone: ''));
  }

  void create(Contact contact) async {
    await _contactRepository.create(contact);
    _contacts.add(contact);
    notifyListeners();
  }

  Future<void> update(Contact contact) async {
    await _contactRepository.update(contact);

    final index = _contacts.indexWhere((item) => item.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    await _contactRepository.delete(id);
    _contacts.removeWhere((contact) => contact.id == id);
    notifyListeners();
  }
}
