import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'db', 'quran.db');
    print('Database path: $path'); // چاپ مسیر دیتابیس برای اطمینان
    return await openDatabase(
      path,
      version: 1,
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<List<Map<String, dynamic>>> getAllAyas() async {
    final db = await database;
    return await db.query('quran_text');
  }

  Future<void> testReadByIndex(int index) async {
    final db = await database;
    try {
      final result = await db.query(
        'quran_text',
        where: '"index" = ?',
        whereArgs: [index],
      );
      print('Result for index $index: $result');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Map<String, dynamic>?> getAyaByIndex(int id) async {
    final db = await database;
    final result = await db.query(
      'quran_text',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> testSelect() async {
    final db = await database;
    final result = await db.rawQuery('SELECT * FROM quran_text LIMIT 1');
    print('Test select result: $result');
  }
}
