class Report {
  int? id;
  String? week;
  DateTime? date;
  String? sede;
  String? docente;
  String? carrera;
  //String? asignatura;
  String? estudiantes;
  String? estudiantespresent;
  String? unidad;
  String? evaluacion;
  String? observaciones;

  Report(
      {this.week,
      this.date,
      this.sede,
      this.docente,
      this.carrera,
      //this.asignatura,
      this.estudiantes,
      this.estudiantespresent,
      this.unidad,
      this.evaluacion,
      this.observaciones});

  Report.withId(
      {this.id,
      this.week,
      this.date,
      this.sede,
      this.docente,
      this.carrera,
      //this.asignatura,
      this.estudiantes,
      this.estudiantespresent,
      this.unidad,
      this.evaluacion,
      this.observaciones});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) {
      map["id"] = id;
    }

    map["week"] = week;
    map["date"] = date!.toIso8601String();
    map["sede"] = sede;
    map["docente"] = docente;
    map["carrera"] = carrera;
    //map["asignatura"] = asignatura;
    map["estudiantes"] = estudiantes;
    map["estudiantespresent"] = estudiantespresent;
    map["unidad"] = unidad;
    map["evaluacion"] = evaluacion;
    map["observaciones"] = observaciones;
    return map;
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report.withId(
      id: map["id"],
      week: map["week"],
      date: DateTime.parse(map["date"]),
      sede: map["sede"],
      docente: map["docente"],
      carrera: map["carrera"],
      //asignatura: map["asignatura"],
      estudiantes: map["estudiantes"],
      estudiantespresent: map["estudiantespresent"],
      unidad: map["unidad"],
      evaluacion: map["evaluacion"],
      observaciones: map["observaciones"],
    );
  }
}
