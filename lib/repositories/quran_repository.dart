import 'package:quran_app/Models/quran_text.dart';

import 'database_helper.dart';

class QuranRepository {
  final DatabaseHelper databaseHelper;

  QuranRepository(this.databaseHelper);

  // Future<QuranText?> getNextAya(int currentAyaIndex) async {
  //   final nextAya = await databaseHelper.getAyaByIndex(currentAyaIndex + 1);
  //   if (nextAya != null) {
  //     return QuranText.fromMap(nextAya);
  //   } else {
  //     return null;
  //   }
  // }

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

  Future<List<QuranText>> getRandomOptions(int correctAyaIndex) async {
    final db = await databaseHelper.database;
    final randomOptions = await db.rawQuery(
      'SELECT * FROM quran_text WHERE id != ? ORDER BY RANDOM() LIMIT 3',
      [correctAyaIndex],
    );
    return randomOptions.map((map) => QuranText.fromMap(map)).toList();
  }
}
