import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/repositories/quiz_service.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizService quizService;

  QuizBloc({required this.quizService}) : super(QuizInitial()) {
    on<StartQuiz>(_onStartQuiz);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<FinishQuiz>(_onFinishQuiz);
  }

  Future<void> _onStartQuiz(StartQuiz event, Emitter<QuizState> emit) async {
    emit(QuizLoading());

    try {
      List<Map<String, dynamic>> questions =
          await quizService.generateRandomQuestions(
        level: event.level,
        selectedTypes: event.selectedTypes,
        questionType: event.questionType,
        startPage: event.startPage,
        endPage: event.endPage,
        questionCount: event.questionCount,
      );

      emit(QuizLoaded(
        questions: questions,
        currentIndex: 0,
        correctAnswers: 0,
        isFinished: false,
      ));
    } catch (e) {
      emit(QuizInitial());
    }
  }

  void _onAnswerQuestion(AnswerQuestion event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      final currentQuestion = currentState.questions[currentState.currentIndex];

      bool isCorrect = event.selectedAnswer == currentQuestion['correctAnswer'];
      int newCorrectAnswers = isCorrect
          ? currentState.correctAnswers + 1
          : currentState.correctAnswers;
      int newIndex = currentState.currentIndex + 1;

      if (newIndex < currentState.questions.length) {
        emit(currentState.copyWith(
            currentIndex: newIndex, correctAnswers: newCorrectAnswers));
      } else {
        emit(QuizFinished(
            correctAnswers: newCorrectAnswers,
            totalQuestions: currentState.questions.length));
      }
    }
  }

  void _onFinishQuiz(FinishQuiz event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      emit(QuizFinished(
          correctAnswers: currentState.correctAnswers,
          totalQuestions: currentState.questions.length));
    }
  }
}
