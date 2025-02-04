import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:quran_app/blocs/bloc/quiz_bloc.dart';
import 'package:quran_app/blocs/bloc/quiz_event.dart';
import 'package:quran_app/blocs/bloc/quiz_state.dart';
import 'package:quran_app/repositories/quiz_service.dart';
import 'package:quran_app/repositories/quran_service.dart';

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _radioValue = 0;
  bool _easy = false;
  bool _medium = false;
  bool _hard = false;
  List<bool> _easyOptions = [false, false, false];
  List<bool> _mediumOptions = [false, false, false];
  List<bool> _hardOptions = [false, false, false];
  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value!;
    });
  }

  void _handleCheckboxChange(bool value, String type, int index) {
    setState(() {
      if (type == 'easy') {
        _easyOptions[index] = value;
      } else if (type == 'medium') {
        _mediumOptions[index] = value;
      } else if (type == 'hard') {
        _hardOptions[index] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quranService = QuranService();
    final quizService = QuizService(quranService: quranService);
    return BlocProvider(
      create: (context) => QuizBloc(quizService: quizService),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Quiz'),
          ),
          body: BlocBuilder<QuizBloc, QuizState>(
            builder: (context, state) {
              if (state is QuizInitial) {
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text('گزینه ۱'),
                        Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text('گزینه ۲'),
                        Radio(
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text('گزینه ۳'),
                        Radio(
                          value: 3,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text('گزینه ۴'),
                      ],
                    ),
                    CheckboxListTile(
                      title: Text('آسان'),
                      value: _easy,
                      onChanged: (bool? value) {
                        setState(() {
                          _easy = value!;
                        });
                      },
                    ),
                    if (_easy)
                      Column(
                        children: List.generate(3, (index) {
                          return CheckboxListTile(
                            title: Text('آسان گزینه ${index + 1}'),
                            value: _easyOptions[index],
                            onChanged: (bool? value) {
                              _handleCheckboxChange(value!, 'easy', index);
                            },
                          );
                        }),
                      ),
                    CheckboxListTile(
                      title: Text('متوسط'),
                      value: _medium,
                      onChanged: (bool? value) {
                        setState(() {
                          _medium = value!;
                        });
                      },
                    ),
                    if (_medium)
                      Column(
                        children: List.generate(3, (index) {
                          return CheckboxListTile(
                            title: Text('متوسط گزینه ${index + 1}'),
                            value: _mediumOptions[index],
                            onChanged: (bool? value) {
                              _handleCheckboxChange(value!, 'medium', index);
                            },
                          );
                        }),
                      ),
                    CheckboxListTile(
                      title: Text('سخت'),
                      value: _hard,
                      onChanged: (bool? value) {
                        setState(() {
                          _hard = value!;
                        });
                      },
                    ),
                    if (_hard)
                      Column(
                        children: List.generate(3, (index) {
                          return CheckboxListTile(
                            title: Text('سخت گزینه ${index + 1}'),
                            value: _hardOptions[index],
                            onChanged: (bool? value) {
                              _handleCheckboxChange(value!, 'hard', index);
                            },
                          );
                        }),
                      ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<QuizBloc>(context).add(StartQuiz(
                            level: 'easy',
                            // selectedTypes: ['translation', 'previous_next'],
                            selectedTypes: ['previous_next'],
                            questionType: 'multiple_choice',
                            startPage: 1,
                            endPage: 10,
                            questionCount: 10,
                          ));
                        },
                        child: Text("Start Quiz"),
                      ),
                    ),
                  ],
                );
              } else if (state is QuizLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is QuizLoaded) {
                var question = state.questions[state.currentIndex];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 30, 8, 30),
                          child: Text(
                              "سوال ${state.currentIndex + 1}: ${question['question']}"),
                        ),
                      ),
                    ),
                    ...(question['options'] as List<String>).map((option) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          width: double.infinity,
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.white)),
                            onPressed: () {
                              BlocProvider.of<QuizBloc>(context)
                                  .add(AnswerQuestion(selectedAnswer: option));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.info_outline),
                                  onPressed: () {
                                    showPlatformDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return BasicDialogAlert(
                                            title: Text(""),
                                            content: Text(
                                              option,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                              ),
                                            ),
                                            actions: <Widget>[
                                              BasicDialogAction(
                                                title: Text("بستن"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              } else if (state is QuizFinished) {
                return Column(
                  children: [
                    Text(
                        "Quiz Finished! Correct Answers: ${state.correctAnswers} / ${state.totalQuestions}"),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<QuizBloc>(context).add(StartQuiz(
                          level: 'easy',
                          selectedTypes: ['translation'],
                          questionType: 'multiple_choice',
                          startPage: 10,
                          endPage: 20,
                          questionCount: 10,
                        ));
                      },
                      child: Text("Restart"),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
