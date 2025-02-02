import 'dart:math';

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
    on<GetSarAya>((event, emit) => _mapGetSarAyaToState(event, emit));

    on<GetAya>(
        (event, emit) => _mapGetAyaToState(event, emit)); // اضافه کردن این خط
  }

  Future<void> _mapGetNextAyaToState(
      GetNextAya event, Emitter<QuranState> emit) async {
    emit(QuranLoading());
    try {
      final nextAya = await quranRepository.getNextAya(event.currentAyaIndex);
      final currentAya =
          await quranRepository.getCurrentAya(event.currentAyaIndex);

      if (nextAya != null && currentAya != null) {
        final randomOptions =
            await quranRepository.getRandomOptions(nextAya.id);
        randomOptions.add(nextAya);
        randomOptions.shuffle(); // ترکیب گزینه‌ها به صورت تصادفی
        emit(QuranLoaded(nextAya, randomOptions, currentAya));
      } else {
        emit(QuranError('آیه بعدی یافت نشد'));
      }
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  // اضافه کردن این تابع
  Future<void> _mapGetAyaToState(GetAya event, Emitter<QuranState> emit) async {
    emit(QuranLoading());
    try {
      final aya =
          await quranRepository.getAya(event.currentAyaIndex, event.number);
      final currentAya =
          await quranRepository.getCurrentAya(event.currentAyaIndex);
      if (aya != null && currentAya != null) {
        final randomOptions = await quranRepository.getRandomOptions(aya.id);
        randomOptions.add(aya);
        emit(QuranLoaded(aya, randomOptions,
            currentAya)); // اینجا فرض شده که به طور مشابه از QuranLoaded استفاده می‌شود
      } else {
        emit(QuranError('آیه مورد نظر یافت نشد'));
      }
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  Future<void> _mapGetSarAyaToState(
      GetSarAya event, Emitter<QuranState> emit) async {
    emit(QuranLoading());
    try {
      List sarAyasOption=[];
      final sarAyas = await quranRepository.getAyaByPage(event.pageNumber);
      for (var i = 0; i < 3; i++) {
        Random random = Random();
        int randomNumber = random.nextInt(101) + 1;
         final option = await quranRepository.getAyaByPage(randomNumber);
         sarAyasOption.add(option);
      }
      
      //   final currentAya =
      //  await quranRepository.getCurrentAya(event.currentAyaIndex);
      if (sarAyas.isNotEmpty) {
        List<String> sarAyatLst=[];
        sarAyas.forEach(
          (element) {
          var saraya =  extractWords(element.text);
          sarAyatLst.add(saraya);
          },
        );
        // emit(QuranLoaded(sarAyatLst, sarAyasOption, event.pageNumber));
      } else {
        emit(QuranError('آیه مورد نظر یافت نشد'));
      }
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

 
    // تابع برای استخراج یک یا دو کلمه از ابتدای آیه
    String extractWords(String verse) {
      List<String> words = verse.split(' ');
      if (words.length >= 2) {
        return '${words[0]} ${words[1]}';
      } else if (words.length == 1) {
        return words[0];
      } else {
        return '';
      }
    }
}




// class QuranBloc extends Bloc<QuranEvent, QuranState> {
//   final QuranRepository quranRepository;

//   QuranBloc(this.quranRepository) : super(QuranInitial()) {
//     on<GetNextAya>((event, emit) => _mapGetNextAyaToState(event, emit));
//   }

//   Future<void> _mapGetNextAyaToState(
//       GetNextAya event, Emitter<QuranState> emit) async {
//     try {
//       final nextAya = await quranRepository.getNextAya(event.currentAyaIndex);
//       final currentAya =
//           await quranRepository.getCurrentAya(event.currentAyaIndex);

//       if (nextAya != null && currentAya != null) {
//         final randomOptions =
//             await quranRepository.getRandomOptions(nextAya.id);
//         randomOptions.add(nextAya);
//         randomOptions.shuffle(); // ترکیب گزینه‌ها به صورت تصادفی
//         emit(QuranLoaded(nextAya, randomOptions, currentAya));
//       } else {
//         emit(QuranError('آیه بعدی یافت نشد'));
//       }
//     } catch (e) {
//       emit(QuranError(e.toString()));
//     }
//   }
// }
