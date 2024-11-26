import 'package:app_contatos/app/database/script.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static const String _dbName = "app_database.db";
  static const int _databaseVersion = 3;

  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    return _initDatabase();
  }

  static Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _dbName);

    final db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(createTable);
    await db.execute(insertContacts);
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    await db.execute(insertContacts);
  }
}
