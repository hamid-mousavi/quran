
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/pages/quiz_settins_page.dart';

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
              MaterialPageRoute(builder: (context) => QuizSettingsPage()),
            );
          },
          child: Text('ورود به تنظیمات آزمون'),
        ),
      ),
    );
  }
}
