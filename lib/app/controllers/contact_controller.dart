import 'dart:async';

import 'package:app_contatos/app/exceptions/contact_not_found_exception.dart';
import 'package:app_contatos/app/exceptions/database_exception.dart';
import 'package:app_contatos/app/exceptions/exist_email_exception.dart';
import 'package:app_contatos/app/exceptions/invalid_contact_exceptions.dart';
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
    try {
      _contacts = await _contactRepository.findAll();
      _isLoading = false;
      return _contacts;
    } catch (e) {
      throw DatabaseException(message: "Erro ao buscar contatos");
    }
  }

  Future<Contact> findById(int id) async {
    try {
      final contact = await _contactRepository.findById(id);

      if (contact == null) {
        throw ContactNotFoundException(message: "Contato não encontrado");
      }

      return contact;
    } on ContactNotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException(
          message: "Erro inesperado tente novamente mais tarde");
    }
  }

  void create(Contact contact) async {
    try {
      if (!contact.validate(contact)) {
        throw InvalidContactException(message: "Formato do contato invalido");
      }

      if (await _contactRepository.findByEmail(contact.email)) {
        throw ExistEmailException(
            message: "Já existe um contato com o e-mail '${contact.email}'.");
      }

      await _contactRepository.create(contact);
      _contacts.add(contact);
      notifyListeners();
    } on InvalidContactException {
      rethrow;
    } on ExistEmailException {
      rethrow;
    } catch (e) {
      throw DatabaseException(
          message: "Erro inesperado tente novamente mais tarde");
    }
  }

  Future<void> update(Contact contact) async {
    try {
      final existingContact = await _contactRepository.findById(contact.id!);
      if (existingContact == null) {
        throw ContactNotFoundException(
            message: "Contato com ID ${contact.id} não encontrado.");
      }

      await _contactRepository.update(contact);

      final index = _contacts.indexWhere((item) => item.id == contact.id);
      if (index != -1) {
        _contacts[index] = contact;
        notifyListeners();
      }
    } on ContactNotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException(
          message: "Erro inesperado tente novamente mais tarde");
    }
  }

  Future<void> delete(int id) async {
    try {
      final existingContact = await _contactRepository.findById(id);
      if (existingContact == null) {
        throw ContactNotFoundException(
            message: "Contato com ID $id não encontrado.");
      }

      await _contactRepository.delete(id);
      _contacts.removeWhere((contact) => contact.id == id);
      notifyListeners();
    } on ContactNotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException(
          message: "Erro inesperado tente novamente mais tarde");
    }
  }
}
