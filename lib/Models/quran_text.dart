class QuranText {
  final int id;
  final int joz;
  final int pageNo;
  final int sura;
  final int aya;
  final String text;
  final String textClean;

  QuranText({
    required this.id,
    required this.joz,
    required this.pageNo,
    required this.sura,
    required this.aya,
    required this.text,
    required this.textClean,
  });

  factory QuranText.fromMap(Map<String, dynamic> map) {
    return QuranText(
      id: map['id'],
      joz: map['joz'],
      pageNo: map['pageNo'],
      sura: map['sura'],
      aya: map['aya'],
      text: map['text'],
      textClean: map['text_clean'],
    );
  }
}
