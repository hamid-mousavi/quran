part of 'quran_bloc.dart';

@immutable
abstract class QuranEvent {}

class GetNextAya extends QuranEvent {
  final int currentAyaIndex;

  GetNextAya(this.currentAyaIndex);
}
class GetAya extends QuranEvent {
  final int currentAyaIndex;
  final int number;

  GetAya(this.currentAyaIndex, this.number);
}
class GetSarAya extends QuranEvent {
  final int pageNumber;

  GetSarAya(this.pageNumber);

}