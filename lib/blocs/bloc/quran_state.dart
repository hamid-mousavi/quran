part of 'quran_bloc.dart';

@immutable
abstract class QuranState {}

class QuranInitial extends QuranState {}

class QuranLoaded extends QuranState {
  final QuranText nextAya;
  final List<QuranText> randomOptions;

  QuranLoaded(this.nextAya, this.randomOptions);
}

class QuranError extends QuranState {
  final String message;

  QuranError(this.message);
}
