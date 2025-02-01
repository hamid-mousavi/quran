import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/Models/quran_text.dart';
import 'package:quran_app/blocs/bloc/quran_bloc.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuranBloc? _quranBloc;
  int _currentAyaIndex = 1; // مقدار اولیه

  @override
  void initState() {
    super.initState();
    _quranBloc = BlocProvider.of<QuranBloc>(context);
    _quranBloc?.add(GetNextAya(_currentAyaIndex));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quran Quiz'),
      ),
      body: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is QuranLoaded) {
            return _buildQuiz(state.nextAya, state.randomOptions);
          } else if (state is QuranError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildQuiz(QuranText nextAya, List<QuranText> options) {
    options.shuffle();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'What is the next verse after ${nextAya.text}?',
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
                  _quranBloc?.add(GetNextAya(_currentAyaIndex));
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
