class Note {
  final int? id;
  final String title;
  final String date;

  Note({this.id, required this.title, required this.date});

  //Send to DB
  Map<String, dynamic> toMap() {
    return {"id": this.id, "title": this.title, "date": this.date};
  }

  //Retrieve from DB
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map["id"],
      title: map["title"],
      date: map["date"],
    );
  }
}
