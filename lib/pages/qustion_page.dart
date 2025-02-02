import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



class QuizQuestionsPage extends StatelessWidget {
  final String answerType;
  final List<String> questionTypes;

  QuizQuestionsPage({required this.answerType, required this.questionTypes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('سوالات')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطا در بارگذاری سوالات'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('سوالی برای نمایش وجود ندارد.'));
          } else {
            final questions = snapshot.data!;

            return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(question['question'] ?? 'سوال بدون عنوان'),
                    subtitle: _buildAnswerOptions(question),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchQuestions() async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'quran.db'),
    );

    final List<Map<String, dynamic>> questions = await db.query('quran_text', limit: 10);
    return _generateQuestions(questions);
  }

  // الگوریتم تولید سوالات از آیات
  List<Map<String, dynamic>> _generateQuestions(List<Map<String, dynamic>> questions) {
    List<Map<String, dynamic>> generatedQuestions = [];
    
    for (var question in questions) {
      String verse = question['verse'] ?? '';
      String questionText = '';

      // تولید سوالات جای‌خالی
      if (questionTypes.contains('جای‌خالی')) {
        questionText = verse.replaceAll(RegExp(r'[\u0600-\u06FF]+'), '__________');
      }

      // تولید سوالات چهار گزینه‌ای
      if (questionTypes.contains('چهار گزینه‌ای')) {
        questionText = 'کدام آیه شامل عبارت "__________" است؟';
      }

      generatedQuestions.add({
        'question': questionText,
        'options': ['گزینه 1', 'گزینه 2', 'گزینه 3', 'گزینه 4'], // شما می‌توانید گزینه‌ها را متناسب با آیه‌ها تغییر دهید
        'answer': 'گزینه 1', // جواب درست
      });
    }

    return generatedQuestions;
  }

  Widget _buildAnswerOptions(Map<String, dynamic> question) {
    switch (answerType) {
      case 'چهار گزینه‌ای':
        return _buildMultipleChoiceOptions(question);
      case 'چینشی':
        return _buildMatchingOptions(question);
      case 'تشریحی':
        return _buildDescriptiveAnswer(question);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildMultipleChoiceOptions(Map<String, dynamic> question) {
    final options = question['options'] as List<String>;
    return Column(
      children: options.map((option) {
        return ListTile(
          title: Text(option),
          leading: Radio(
            value: option,
            groupValue: question['selectedAnswer'],
            onChanged: (value) {
              // انتخاب کاربر را ذخیره کنید
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMatchingOptions(Map<String, dynamic> question) {
    return Column(
      children: [
        // پیاده‌سازی سوالات چینشی
      ],
    );
  }

  Widget _buildDescriptiveAnswer(Map<String, dynamic> question) {
    return TextField(
      onChanged: (value) {
        // ذخیره پاسخ تشریحی
      },
      decoration: InputDecoration(
        hintText: 'پاسخ تشریحی خود را بنویسید...',
        border: OutlineInputBorder(),
      ),
    );
  }
}
