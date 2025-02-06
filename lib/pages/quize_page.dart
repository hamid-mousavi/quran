import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:google_fonts/google_fonts.dart';
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
            // leading: Icon(Icons.arrow_back, color: Colors.white),
            actions: [
              Icon(Icons.settings, color: Colors.white),
              SizedBox(width: 16),
            ],
          ),
          body: BlocBuilder<QuizBloc, QuizState>(
            builder: (context, state) {
              if (state is QuizInitial) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
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
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: const InputDecoration(
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
                                child: Text(
                                  "شروع",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is QuizLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is QuizLoaded) {
                var question = state.questions[state.currentIndex];
                return QuizePageWidget(state, question, context);
              } else if (state is QuizFinished) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'پایان\n',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "جواب درست: ${state.correctAnswers} از ${state.totalQuestions}"),
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
                        child: Text("شروع دوباره"),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView QuizePageWidget(
      QuizLoaded state, Map<String, dynamic> question, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.5), // رنگ سایه با شفافیت ۱۵٪
                        offset: Offset(0, 10), // موقعیت سایه (x=0, y=20)
                        spreadRadius: -10, // گسترش سایه
                        blurRadius: 30, // محو شدن سایه
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 30, 16, 20),
                    child: Text(
                      style: TextStyle(
                          fontFamily: GoogleFonts.amiri().fontFamily,
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      " ${question['question']}",
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 45),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        value: state.currentIndex / 10, // مقدار پیشرفت
                        strokeWidth: 6,
                        backgroundColor: Color(0xffABD1C6),

                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff004643)),
                      ),
                    ),
                    Text("${state.currentIndex + 1}"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
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
                    foregroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Color(0xff004643); // رنگ متن هنگام هاور
                        }
                        return Color(0xff004643); // رنگ متن پیش‌فرض
                      },
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Color(0xffABD1C6); // رنگ پس‌زمینه هنگام هاور
                        }
                        return Colors.white; // رنگ پس‌زمینه پیش‌فرض
                      },
                    ),
                    overlayColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.blue.withOpacity(0.2); // رنگ هنگام کلیک
                        }
                        return Colors.transparent; // رنگ پیش‌فرض
                      },
                    ),
                  ),
                  onPressed: () {
                     Future.delayed(Duration(seconds: 1), () {
                      BlocProvider.of<QuizBloc>(context)
                        .add(AnswerQuestion(selectedAnswer: option));
                    });
                   
                   
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'osmantaha',
                              fontSize: 22),
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
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(20),
            width: double.infinity,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                  Color(0xff004643),
                )),
                onPressed: () {},
                child: Text(
                  'پایان',
                  style: TextStyle(
                    color: Color(0xffffffff),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
