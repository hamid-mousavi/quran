import 'package:equatable/equatable.dart';

abstract class QuizState extends Equatable {
  @override
  List<Object?> get props => [];
  
}

// 🔹 وضعیت اولیه آزمون
class QuizInitial extends QuizState {}

// 🔹 بارگذاری سوالات
class QuizLoading extends QuizState {}

// 🔹 نمایش سوالات و گزینه‌ها
class QuizLoaded extends QuizState {
  final List<Map<String, dynamic>> questions;
  final int currentIndex;
  final int correctAnswers;
  final bool isFinished;

  QuizLoaded({
    required this.questions,
    required this.currentIndex,
    required this.correctAnswers,
    required this.isFinished,
  });

  @override
  List<Object?> get props => [questions, currentIndex, correctAnswers, isFinished];

  QuizLoaded copyWith({
    List<Map<String, dynamic>>? questions,
    int? currentIndex,
    int? correctAnswers,
    bool? isFinished,
  }) {
    return QuizLoaded(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

// 🔹 نمایش نتیجه آزمون
class QuizFinished extends QuizState {
  final int correctAnswers;
  final int totalQuestions;

  QuizFinished({required this.correctAnswers, required this.totalQuestions});

  @override
  List<Object?> get props => [correctAnswers, totalQuestions];
}
