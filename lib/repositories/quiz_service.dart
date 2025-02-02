import 'dart:math';
import 'package:quran_app/Models/quran_text.dart';
import 'quran_service.dart';

class QuizService {
  final QuranService quranService;

  QuizService({required this.quranService});

  Future<List<Map<String, dynamic>>> generateRandomQuestions({
    required String level,
    required List<String> selectedTypes, // انتخاب‌هایی که کاربر فعال کرده
    required String questionType, // ۴ گزینه‌ای یا تشریحی
    required int startPage, // صفحه‌ی شروع
    required int endPage, // صفحه‌ی پایان
    int questionCount = 20,
  }) async {
    List<Map<String, dynamic>> questions = [];
    List<QuranText> verses = await _getRandomVerses(level, questionCount, startPage, endPage);

    for (var i = 0; i < questionCount; i++) {
      var verse = verses[i];

      for (var type in selectedTypes) {
        Map<String, dynamic>? question;
        if (type == 'translation') {
          question = await _createTranslationQuestion(verse, questionType);
        } else if (type == 'previous_next') {
          question = await _createPreviousNextQuestion(verse, questionType);
        } else if (type == 'sura_start') {
          question = await _createSuraStartQuestion(verse, questionType);
        }

        if (question != null) questions.add(question);
      }
    }

    return questions.take(questionCount).toList();
  }

  Future<List<QuranText>> _getRandomVerses(String level, int count, int startPage, int endPage) async {
    Random rand = Random();
    List<QuranText> verses = [];
    var pages = List.generate(endPage - startPage + 1, (index) => startPage + index); // صفحات مشخص‌شده

    for (var i = 0; i < count; i++) {
      int pageNo = pages[rand.nextInt(pages.length)];
      var verseList = await quranService.getVersesByPage(pageNo);
      if (verseList.isNotEmpty) verses.add(verseList[rand.nextInt(verseList.length)]);
    }
    return verses;
  }

  Future<Map<String, dynamic>> _createTranslationQuestion(QuranText verse, String questionType) async {
    if (questionType == 'multiple_choice') {
      var correctAnswer = verse.textClean;
      var wrongAnswers = await _getWrongAnswers(verse.sura, verse.aya);
      var options = [correctAnswer, ...wrongAnswers]..shuffle();

      return {
        'question': 'What is the translation of this verse?',
        'options': options,
        'correctAnswer': correctAnswer,
      };
    } else {
      return {
        'question': 'Explain the meaning of this verse: ${verse.textClean}',
        'correctAnswer': verse.textClean,
      };
    }
  }

  Future<Map<String, dynamic>> _createPreviousNextQuestion(QuranText verse, String questionType) async {
    var prevVerse = await quranService.getVerseBySuraAya(verse.sura, verse.aya - 1);
    var nextVerse = await quranService.getVerseBySuraAya(verse.sura, verse.aya + 1);

    if (questionType == 'multiple_choice') {
      return {
        'question': 'What is the next verse after this?\n"${verse.textClean}"',
        'options': [nextVerse?.textClean ?? '', prevVerse?.textClean ?? '', 'Another verse', 'Wrong verse']..shuffle(),
        'correctAnswer': nextVerse?.textClean ?? '',
      };
    } else {
      return {
        'question': 'What is the previous and next verse for this?\n"${verse.textClean}"',
        'correctAnswer': '${prevVerse?.textClean ?? ''} / ${nextVerse?.textClean ?? ''}',
      };
    }
  }

  Future<Map<String, dynamic>> _createSuraStartQuestion(QuranText verse, String questionType) async {
    bool isStart = verse.aya == 1;
    return {
      'question': 'Is this the first verse of a Surah?',
      'options': ['Yes', 'No'],
      'correctAnswer': isStart ? 'Yes' : 'No',
    };
  }

  Future<List<String>> _getWrongAnswers(int sura, int aya) async {
    Random rand = Random();
    List<String> wrongAnswers = [];
    for (var i = 0; i < 3; i++) {
      int randomSura = rand.nextInt(114) + 1;
      int randomAya = rand.nextInt(100) + 1;
      var wrongVerse = await quranService.getVerseBySuraAya(randomSura, randomAya);
      if (wrongVerse != null) wrongAnswers.add(wrongVerse.textClean);
    }
    return wrongAnswers;
  }
}
