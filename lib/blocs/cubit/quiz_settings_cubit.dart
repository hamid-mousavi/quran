import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'quiz_settings_state.dart';
// Bloc برای مدیریت انتخاب‌های کاربر
class QuizSettingsCubit extends Cubit<Map<String, dynamic>> {
  QuizSettingsCubit()
      : super({
          'questionTypes': [],
          'answerType': 'چهار گزینه‌ای',
        });

  void toggleQuestionType(String type) {
    List<String> updatedTypes = List.from(state['questionTypes']);
    if (updatedTypes.contains(type)) {
      updatedTypes.remove(type);
    } else {
      updatedTypes.add(type);
    }
    emit({'questionTypes': updatedTypes, 'answerType': state['answerType']});
  }

  void setAnswerType(String type) {
    emit({'questionTypes': state['questionTypes'], 'answerType': type});
  }
}