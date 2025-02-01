part of 'quran_bloc.dart';

@immutable
abstract class QuranEvent {}

class GetNextAya extends QuranEvent {
  final int currentAyaIndex;

  GetNextAya(this.currentAyaIndex);
}
