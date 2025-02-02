
import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// 🔹 شروع آزمون و گرفتن سوالات تصادفی
class StartQuiz extends QuizEvent {
  final String level;
  final List<String> selectedTypes;
  final String questionType;
  final int startPage;
  final int endPage;
  final int questionCount;

  StartQuiz({
    required this.level,
    required this.selectedTypes,
    required this.questionType,
    required this.startPage,
    required this.endPage,
    required this.questionCount,
  });

  @override
  List<Object?> get props => [level, selectedTypes, questionType, startPage, endPage, questionCount];
}

// 🔹 پاسخ دادن به سوال
class AnswerQuestion extends QuizEvent {
  final String selectedAnswer;

  AnswerQuestion({required this.selectedAnswer});

  @override
  List<Object?> get props => [selectedAnswer];
}

// 🔹 پایان آزمون و نمایش نتیجه
class FinishQuiz extends QuizEvent {}
