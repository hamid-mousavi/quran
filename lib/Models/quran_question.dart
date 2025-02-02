abstract class QuranQuestion {
  String questionText;
  QuranQuestion(this.questionText);

  void displayQuestion();
}
class MultipleChoiceQuestion extends QuranQuestion {
  List<String> options;
  String correctAnswer;

  MultipleChoiceQuestion(String questionText, this.options, this.correctAnswer)
      : super(questionText);

  @override
  void displayQuestion() {
    print(questionText);
    for (var i = 0; i < options.length; i++) {
      print("${i + 1}. ${options[i]}");
    }
  }
}

class DescriptiveQuestion extends QuranQuestion {
  DescriptiveQuestion(String questionText) : super(questionText);

  @override
  void displayQuestion() {
    print(questionText);
  }
}

class AudioQuestion extends QuranQuestion {
  String audioUrl;

  AudioQuestion(String questionText, this.audioUrl) : super(questionText);

  @override
  void displayQuestion() {
    print(questionText);
    print("Audio URL: $audioUrl");
  }
}