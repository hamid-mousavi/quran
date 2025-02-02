import 'package:quran_app/Models/quran_text.dart';

import 'database_helper.dart';

class QuranRepository {
  final DatabaseHelper databaseHelper;

  QuranRepository(this.databaseHelper);
  Future<QuranText?> getAya(int currentAyaIndex, int number) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'quran_text',
      where: '"id" = ?',
      whereArgs: [currentAyaIndex + number],
    );

    if (result.isNotEmpty) {
      return QuranText.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<QuranText>> getAyaByPage(int pageNumber) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'quran_text',
      where: 'pageNo = ?', // فرض شده که ستون صفحه به نام 'page' است
      whereArgs: [pageNumber],
    );

    if (result.isNotEmpty) {
      return result.map((map) => QuranText.fromMap(map)).toList();
    } else {
      return [];
    }
  }

  Future<QuranText?> getNextAya(int currentAyaIndex) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'quran_text',
      where: '"id" = ?',
      whereArgs: [currentAyaIndex + 1],
    );

    if (result.isNotEmpty) {
      return QuranText.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<QuranText?> getCurrentAya(int currentAyaIndex) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'quran_text',
      where: '"id" = ?',
      whereArgs: [currentAyaIndex],
    );

    if (result.isNotEmpty) {
      return QuranText.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<QuranText>> getRandomOptions(int correctAyaIndex) async {
    final db = await databaseHelper.database;
    final randomOptions = await db.rawQuery(
      'SELECT * FROM quran_text WHERE id != ? ORDER BY RANDOM() LIMIT 3',
      [correctAyaIndex],
    );
    return randomOptions.map((map) => QuranText.fromMap(map)).toList();
  }

  Future<List<QuranText>> getRandomOptionsForAyaByPage(int correctPageNumber) async {
    final db = await databaseHelper.database;
    final randomOptions = await db.rawQuery(
      'SELECT * FROM quran_text WHERE pageNo != ? ORDER BY RANDOM() LIMIT 3',
      [correctPageNumber],
    );
    return randomOptions.map((map) => QuranText.fromMap(map)).toList();
    
  }



  
}
