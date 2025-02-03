
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/pages/quiz_page_test.dart';
import 'package:quran_app/pages/quiz_settins_page.dart';
import 'package:quran_app/pages/quize_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('خانه')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizPageTest()),
            );
          },
          child: Text('ورود به تنظیمات آزمون'),
        ),
      ),
    );
  }
}
