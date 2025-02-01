import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/Models/quran_text.dart';
import 'package:quran_app/blocs/bloc/quran_bloc.dart';

// int randomNumber = random.nextInt(101) + 1;
int randomNumber = 2;
int numberNextAyae = 1;

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuranBloc? _quranBloc;
  int _currentAyaIndex = randomNumber; // مقدار اولیه

  @override
  void initState() {
    super.initState();
    _quranBloc = BlocProvider.of<QuranBloc>(context);
    // _quranBloc?.add(GetNextAya(_currentAyaIndex));
    _quranBloc?.add(GetAya(_currentAyaIndex, numberNextAyae));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
            textDirection: TextDirection.rtl,

      child: Scaffold(
        appBar: AppBar(
          title: Text('Quran Quiz'),
        ),
        body: BlocBuilder<QuranBloc, QuranState>(
          builder: (context, state) {
            if (state is QuranInitial) {
              return Center(child: CircularProgressIndicator());
            } else if (state is QuranLoaded) {
              return _buildQuiz(
                state.nextAya,
                state.currentAya,
                state.randomOptions,
              );
            } else if (state is QuranError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildQuiz(
      QuranText nextAya, QuranText currentAya, List<QuranText> options) {
    options.shuffle();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            '$numberNextAyae'
            ' آیه بعد از ${currentAya.text} چیست؟',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 20.0),
          for (var option in options)
            ElevatedButton(
              onPressed: () {
                if (option.id == nextAya.id) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Correct!')),
                  );
                  // درخواست آیه بعدی برای سوال بعدی
                  _currentAyaIndex = nextAya.id;
                  _quranBloc?.add(GetAya(_currentAyaIndex,numberNextAyae));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Wrong! Try again.')),
                  );
                }
              },
              child: Text(option.text),
            ),
        ],
      ),
    );
  }
}
