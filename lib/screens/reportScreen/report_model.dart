/*class Report {
  int? id;
  String? title;
  DateTime? date;
  String? priority;
  int? status;

  Report({this.title, this.date, this.priority, this.status});

  Report.withId({this.id, this.title, this.date, this.priority, this.status});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) {
      map["id"] = id;
    }

    map["title"] = title;
    map["date"] = date!.toIso8601String();
    map["priority"] = priority;
    map["status"] = status;
    return map;
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report.withId(
      id: map["id"],
      title: map["title"],
      date: DateTime.parse(map["date"]),
      priority: map["priority"],
      status: map["status"],
    );
  }
}*/
