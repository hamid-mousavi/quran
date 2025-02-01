import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran_app/Models/quran_text.dart';
import 'package:quran_app/repositories/quran_repository.dart';

part 'quran_event.dart';
part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final QuranRepository quranRepository;

  QuranBloc(this.quranRepository) : super(QuranInitial()) {
    on<GetNextAya>((event, emit) => _mapGetNextAyaToState(event, emit));
  }

  Future<void> _mapGetNextAyaToState(GetNextAya event, Emitter<QuranState> emit) async {
    try {
      final nextAya = await quranRepository.getNextAya(event.currentAyaIndex);
      if (nextAya != null) {
        final randomOptions = await quranRepository.getRandomOptions(nextAya.id);
        randomOptions.add(nextAya);
        randomOptions.shuffle(); // ترکیب گزینه‌ها به صورت تصادفی
        emit(QuranLoaded(nextAya, randomOptions));
      } else {
        emit(QuranError('آیه بعدی یافت نشد'));
      }
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }
}
