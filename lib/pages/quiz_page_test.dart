import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuizPageTest extends StatefulWidget {
  @override
  _QuizPageTestState createState() => _QuizPageTestState();
}

class _QuizPageTestState extends State<QuizPageTest> {
  int _currentQuestionIndex = 0; // Start from the first question
  int _correctAnswers = 5;
  int _wrongAnswers = 7;
  int _totalQuestions = 35;
  List<String> _questions = [
    "How many students in your class ...from Korea?",
    "Which planet is known as the Red Planet?",
    "What is the capital of France?",
    // Add more questions here
  ];
  List<List<String>> _choices = [
    ["come", "comes", "are coming", "came"],
    ["Earth", "Mars", "Jupiter", "Venus"],
    ["Berlin", "Madrid", "Paris", "Rome"],
    // Add choices corresponding to the questions
  ];
  int _selectedChoice = -1;

  void _submitAnswer() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Handle the end of the quiz
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        hintColor: Colors.purpleAccent,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.purple, 
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quiz Page'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _goToPreviousQuestion,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Question ${_currentQuestionIndex + 1} of $_totalQuestions'),
                  Spacer(),
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 5.0,
                    percent: _currentQuestionIndex / _totalQuestions,
                    center: new Text(
                      "${((_currentQuestionIndex / _totalQuestions) * 100).toStringAsFixed(0)}%",
                      style: TextStyle(color: Colors.black),
                    ),
                    progressColor: Colors.purple,
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Icon(Icons.check, color: Colors.green),
                      Text(' $_correctAnswers '),
                      Icon(Icons.close, color: Colors.orange),
                      Text(' $_wrongAnswers '),
                    ],
                  ),
                ],
              ),
              Divider(),
              Text(
                _questions[_currentQuestionIndex],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ..._choices[_currentQuestionIndex].map((choice) {
                return RadioListTile(
                  title: Text(choice),
                  value: _choices[_currentQuestionIndex].indexOf(choice),
                  groupValue: _selectedChoice,
                  onChanged: (value) {
                    setState(() {
                      _selectedChoice = value!;
                    });
                  },
                );
              }).toList(),
              Spacer(),
              ElevatedButton(
                onPressed: _submitAnswer,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
