import 'package:app_contatos/app/database/database_manager.dart';
import 'package:app_contatos/app/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository {
  Future<List<Contact>> findAll() async {
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
  }

  Future<void> create(Contact contact) async {
    final db = await DatabaseManager.getDatabase();
    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Contact contact) async {
    final db = await DatabaseManager.getDatabase();
    await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseManager.getDatabase();
    await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
