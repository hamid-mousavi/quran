import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/pages/quiz_page_test.dart';
import 'package:quran_app/pages/quiz_settins_page.dart';
import 'package:quran_app/pages/quize_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('خانه')),
      body: Column(
        children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizPage()),
                        );
                      },
                      child:  SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(CupertinoIcons.question_circle_fill),
                            Text('آزمون')
                          ],
                        ),
                      )),
                ),
          
          Center(
            child: Wrap(
              spacing: 8.0, // فاصله افقی بین المان‌ها
              runSpacing: 8.0, // فاصله عمودی بین خطوط
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuizPage()),
                      );
                    },
                    child: const SizedBox(
                      width: 100,
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(CupertinoIcons.question_circle_fill),
                          Text('آزمون')
                        ],
                      ),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuizPage()),
                      );
                    },
                    child: const SizedBox(
                      width: 100,
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(CupertinoIcons.question_circle_fill),
                          Text('آزمون')
                        ],
                      ),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuizPage()),
                      );
                    },
                    child: const SizedBox(
                      width: 100,
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(CupertinoIcons.question_circle_fill),
                          Text('آزمون')
                        ],
                      ),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuizPage()),
                      );
                    },
                    child: const SizedBox(
                      width: 100,
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(CupertinoIcons.question_circle_fill),
                          Text('آزمون')
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
