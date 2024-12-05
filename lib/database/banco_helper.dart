import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:projeto_avaliativo_3/models/keyword.dart';

class DatabaseHelper {
  static const databaseFileName = 'keywords.db';
  static const databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    await _initializeDatabase();
    return _database!;
  }

  Future<void> _initializeDatabase() async {
    if (_database != null) return;

    String dbPath = await getDatabasesPath();
    String fullPath = join(dbPath, databaseFileName);

    _database = await openDatabase(
      fullPath,
      version: databaseVersion,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE keyword (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        keyword TEXT NOT NULL,
        createdDate TEXT NOT NULL,
        fetchActive INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  Future<int> insertKeyword(Keyword keyword) async {
    final db = await database;
    return await db.insert(
      'keyword',
      {
        'keyword': keyword.keyword,
        'createdDate': keyword.createdDate.toIso8601String(),
        'fetchActive': keyword.fetchActive ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteKeyword(int id) async {
    final db = await database;
    return await db.delete('keyword', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Keyword>> getKeywords() async {
    final db = await database;
    final List<Map<String, Object?>> dbKeywords = await db.query('keyword');

    return dbKeywords.map((keywordMap) {
      return Keyword(
        keyword: keywordMap['keyword'] as String,
        fetchActive: (keywordMap['fetchActive'] as int) == 1,
        createdDate: DateTime.parse(keywordMap['createdDate'] as String),
      );
    }).toList();
  }
}
