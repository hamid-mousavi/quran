import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Color myColor = Colors.black;
  List<bool> _easyOptions = [false, false, false];
  List<bool> _mediumOptions = [false, false, false];
  List<bool> _hardOptions = [false, false, false];
  List<String> _levelTxt = ['easy', 'meduim', 'hard'];
  List<String> _questionTypeTxt = ['multiple_choice'];
  List<String> _typeTxt = ['translation', 'previous_next', 'sura_start'];
  List<String> _typePersianTxt = ['ترجمه', 'آیه بعدی و قبلی', 'شروع سوره'];

  List<String> selectedTypes = [];
  final _formKey = GlobalKey<FormState>();
  int? startPage = 1;
  int? endPage = 604;

  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value!;
    });
  }

  void _handleCheckboxChange(
      bool value, String type, int index, String _typeTxt) {
    setState(() {
      if (type == 'easy') {
        _easyOptions[index] = value;
        if (value) {
          selectedTypes.add(_typeTxt);
        } else {
          selectedTypes.remove(_typeTxt);
        }
        print(selectedTypes);
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
                        Text('چهارگزینه ای'),
                        Radio(
                          value: 1,
                          groupValue: _radioValue,
                          // onChanged: _handleRadioValueChange,
                          onChanged: (value) {},
                        ),
                        Text('تشریحی'),
                        Radio(
                          value: 2,
                          groupValue: _radioValue,
                          // onChanged: _handleRadioValueChange,
                          onChanged: (value) {},
                        ),
                        Text('صوتی'),
                        Radio(
                          value: 3,
                          groupValue: _radioValue,
                          // onChanged: _handleRadioValueChange,
                          onChanged: (value) {},
                        ),
                        Text('صوتی'),
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
                            title: Text(_typePersianTxt[index]),
                            value: _easyOptions[index],
                            onChanged: (bool? value) {
                              _handleCheckboxChange(
                                  value!, _levelTxt[0], index, _typeTxt[index]);
                            },
                          );
                        }),
                      ),
                    // CheckboxListTile(
                    //   title: Text(_levelTxt[1]),
                    //   value: _medium,
                    //   onChanged: (bool? value) {
                    //     setState(() {
                    //       _medium = value!;
                    //     });
                    //   },
                    // ),
                    // if (_medium)
                    //   Column(
                    //     children: List.generate(3, (index) {
                    //       return CheckboxListTile(
                    //         title: Text('متوسط گزینه ${index + 1}'),
                    //         value: _mediumOptions[index],
                    //         onChanged: (bool? value) {
                    //           _handleCheckboxChange(
                    //               value!, _levelTxt[1], index, _typeTxt[index]);
                    //         },
                    //       );
                    //     }),
                    //   ),
                    // CheckboxListTile(
                    //   title: Text(_levelTxt[2]),
                    //   value: _hard,
                    //   onChanged: (bool? value) {
                    //     setState(() {
                    //       _hard = value!;
                    //     });
                    //   },
                    // ),
                    // if (_hard)
                    //   Column(
                    //     children: List.generate(3, (index) {
                    //       return CheckboxListTile(
                    //         title: Text('سخت گزینه ${index + 1}'),
                    //         value: _hardOptions[index],
                    //         onChanged: (bool? value) {
                    //           _handleCheckboxChange(
                    //               value!, _levelTxt[2], index, _typeTxt[index]);
                    //         },
                    //       );
                    //     }),
                    //   ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(                            
                              labelText: 'شروع صفحه',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType:
                                TextInputType.number, // صفحه‌کلید عددی
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly // فقط اعداد مجاز هستند
                            ],
                            onChanged: (value) {
                              setState(() {
                                startPage =
                                    int.tryParse(value); // تبدیل مقدار به int
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'لطفاً Start Page را وارد کنید';
                              }
                              if (int.tryParse(value) == null) {
                                return 'لطفاً یک عدد معتبر وارد کنید';
                              }
                              final intValue = int.parse(value);
                              if (intValue > 604) {
                                return 'عدد باید حداکثر 604 باشد';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'پایان صفحه',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType:
                                TextInputType.number, // صفحه‌کلید عددی
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly // فقط اعداد مجاز هستند
                            ],
                            onChanged: (value) {
                              setState(() {
                                endPage =
                                    int.tryParse(value); // تبدیل مقدار به int
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'لطفاً Start Page را وارد کنید';
                              }
                              if (int.tryParse(value) == null) {
                                return 'لطفاً یک عدد معتبر وارد کنید';
                              }
                              final intValue = int.parse(value);
                              if (intValue > 604) {
                                return 'عدد باید حداکثر 604 باشد';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (selectedTypes.isNotEmpty) {
                                  BlocProvider.of<QuizBloc>(context)
                                      .add(StartQuiz(
                                    level: 'easy',
                                    selectedTypes: selectedTypes,
                                    questionType: 'multiple_choice',
                                    startPage: startPage!,
                                    endPage: endPage!,
                                    questionCount: 10,
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("یکی از گزینه ها را انتخاب کنید"),
                                  ));
                                }
                              },
                              child: Text("شروع", style: TextStyle(fontSize: 20),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (state is QuizLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is QuizLoaded) {
                var question = state.questions[state.currentIndex];
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.3), // رنگ سایه با شفافیت ۱۵٪
                                  offset:
                                      Offset(0, 20), // موقعیت سایه (x=0, y=20)
                                  spreadRadius: -5, // گسترش سایه
                                  blurRadius: 20, // محو شدن سایه
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 30, 8, 30),
                            child: Column(
                              children: [
                                Text(
                                    style: const TextStyle(
                                        fontFamily: 'osmantaha',
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    "سوال ${state.currentIndex + 1}: ${question['question']}"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
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
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Colors.white; // رنگ متن هنگام هاور
                                    }
                                    return Colors.blue; // رنگ متن پیش‌فرض
                                  },
                                ),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Colors
                                          .blue; // رنگ پس‌زمینه هنگام هاور
                                    }
                                    return Colors
                                        .transparent; // رنگ پس‌زمینه پیش‌فرض
                                  },
                                ),
                                overlayColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.blue
                                          .withOpacity(0.2); // رنگ هنگام کلیک
                                    }
                                    return Colors.transparent; // رنگ پیش‌فرض
                                  },
                                ),
                              ),
                              onPressed: () {
                                BlocProvider.of<QuizBloc>(context).add(
                                    AnswerQuestion(selectedAnswer: option));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Text(
                                      style: TextStyle(color: Colors.black),
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
                  ),
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
                          selectedTypes: selectedTypes,
                          questionType: 'multiple_choice',
                          startPage: startPage!,
                          endPage: endPage!,
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
