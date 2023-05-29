class NoteModel {
  final int? id;
  final String? title;
  final String? desc;
  final String? dateandtime;

  NoteModel({this.id, this.title, this.desc, this.dateandtime});

  NoteModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        desc = res["desc"],
        dateandtime = res["dateandtime"];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "desc": desc,
      "dateandtime": dateandtime,
    };
  }
}
