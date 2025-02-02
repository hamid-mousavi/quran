import 'package:quran_app/Models/quran_text.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuranService {
  static Database? _database;

  // دسترسی به دیتابیس
  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      join(await getDatabasesPath(), 'quran.db'),
      version: 1,
    );
    return _database!;
  }

  // دریافت آیه بر اساس شماره صفحه
  Future<List<QuranText>> getVersesByPage(int pageNo) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'quran_text',
      where: 'pageNo = ?',
      whereArgs: [pageNo],
    );
    return List.generate(maps.length, (i) {
      return QuranText.fromMap(maps[i]);
    });
  }

  // دریافت آیه خاص بر اساس شماره سوره و شماره آیه
  Future<QuranText?> getVerseBySuraAya(int sura, int aya) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'quran_text',
      where: 'sura = ? AND aya = ?',
      whereArgs: [sura, aya],
    );
    if (maps.isNotEmpty) {
      return QuranText.fromMap(maps.first);
    }
    return null;
  }

  // دریافت ترجمه آیه (می‌تواند از جدول‌های دیگر ترجمه‌ها بیاید)
  // در حال حاضر فقط برای نمونه:
  Future<String> getTranslation(int sura, int aya) async {
    final verse = await getVerseBySuraAya(sura, aya);
    return verse?.textClean ?? 'ترجمه‌ای یافت نشد';
  }

  // سوالات سطح آسان: آیه قبلی و بعدی
  Future<Map<String, String>> getPreviousAndNextVerse(int sura, int aya) async {
    final db = await getDatabase();
    final prevAya = aya - 1 > 0
        ? await getVerseBySuraAya(sura, aya - 1)
        : null;
    final nextAya = await getVerseBySuraAya(sura, aya + 1);

    return {
      'previous': prevAya?.text ?? 'آیه قبلی وجود ندارد',
      'next': nextAya?.text ?? 'آیه بعدی وجود ندارد',
    };
  }

  // سوالات سطح متوسط: سرآیه‌های صفحه خاص
  Future<List<QuranText>> getSurahHeadersByPage(int pageNo) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'quran_text',
      where: 'pageNo = ?',
      whereArgs: [pageNo],
    );
    return List.generate(maps.length, (i) {
      return QuranText.fromMap(maps[i]);
    });
  }

  // سوالات سطح سخت: تحلیل مفهومی
  Future<String> getConceptualAnalysis(int sura, int aya) async {
    // این متد می‌تواند شامل تحلیل‌های پیچیده‌تر یا اتصال به پایگاه داده‌های تفسیری باشد.
    // برای نمونه در اینجا فقط متن آیه را برمی‌گردانیم
    final verse = await getVerseBySuraAya(sura, aya);
    return 'تحلیل مفهومی آیه: ${verse?.text}';
  }
}
