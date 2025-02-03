import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/blocs/bloc/quiz_bloc.dart';
import 'package:quran_app/blocs/bloc/quiz_state.dart';
import 'package:quran_app/pages/quize_page.dart';

class QuizSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تنظیمات آزمون')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(),));
          }, child: Text('آزمون')),
        ),
      ),
    );
  }
}

String levelToString(Level level) {
  switch (level) {
    case Level.easy:
      return 'آسان';
    case Level.medium:
      return 'متوسط';
    case Level.hard:
      return 'سخت';
  }
}
enum QuestionType {
  multipleChoice,
  trueFalse,
  fillInTheBlank,
}

enum Level {
  easy,
  medium,
  hard,
}
