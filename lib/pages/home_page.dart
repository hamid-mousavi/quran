import 'package:flutter/material.dart';
import 'package:quran_app/pages/audio_player_page.dart';
import 'package:quran_app/pages/plan_page.dart';
import 'package:quran_app/pages/quize_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حفظ قرآن'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'پیشرفت شما:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AudioPlayerPage()),
                );
              },
              child: Text('شروع حفظ'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlanPage()),
                );
              },
              child: Text('برنامه‌ریزی'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              child: Text('آزمون'),
            ),
            SizedBox(height: 20),
            Text(
              'یادآوری‌های امروز:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // می‌توانید بخش یادآوری‌ها را اینجا اضافه کنید
          ],
        ),
      ),
    );
  }
}
