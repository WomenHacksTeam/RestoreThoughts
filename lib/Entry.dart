class Entry {
  int id;
  DateTime date;
  String text;
  int score;

  Entry({this.id, this.date, this.text, this.score});

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'text': text, 'score': score};
  }
}
