import 'package:app_contatos/app/database/database_manager.dart';
import 'package:app_contatos/app/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository {
  Future<List<Contact>> findAll() async {
    try {
      final db = await DatabaseManager.getDatabase();

      final List<Map<String, dynamic>> contacts = await db.query('contacts');

      return List.generate(contacts.length, (i) {
        return Contact(
          id: contacts[i]['id'],
          name: contacts[i]['name'],
          email: contacts[i]['email'],
          phone: contacts[i]['phone'],
        );
      });
    } catch (e) {
      throw Exception("Erro ao buscar contatos: $e");
    }
  }

  Future<Contact?> findById(int id) async {
    try {
      final db = await DatabaseManager.getDatabase();

      final result = await db.query(
        'contacts',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        return null;
      }

      return Contact(
        id: result.first['id'] as int,
        name: result.first['name'] as String,
        email: result.first['email'] as String,
        phone: result.first['phone'] as String,
      );
    } catch (e) {
      throw Exception("Erro ao buscar contato: $e");
    }
  }

  Future<bool> existsByEmail(String email) async {
    final db = await DatabaseManager.getDatabase();
    final result = await db.query(
      'contacts',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<int> create(Contact contact) async {
    try {
      final db = await DatabaseManager.getDatabase();
      final id = await db.insert(
        'contacts',
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return id;
    } catch (e) {
      throw Exception("Erro inesperado: $e");
    }
  }

  Future<void> update(Contact contact) async {
    try {
      final db = await DatabaseManager.getDatabase();
      await db.update(
        'contacts',
        contact.toMap(),
        where: 'id = ?',
        whereArgs: [contact.id],
      );
    } catch (e) {
      throw Exception("Erro ao atualizar contato: $e");
    }
  }

  Future<void> delete(int id) async {
    try {
      final db = await DatabaseManager.getDatabase();
      await db.delete(
        'contacts',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception("Erro ao deletar contato: $e");
    }
  }
}
