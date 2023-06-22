import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uniprocess_app/screens/reportScreen/report_model.dart';

class DBHelperReport2 {
  static final DBHelperReport2 instance = DBHelperReport2._instance();

  static Database? _db;

  DBHelperReport2._instance();

  String reportTable = "report_table";
  String colId = "id";
  String colWeek = "week";
  String colDate = "date";
  String colSede = "sede";
  String colDocente = "docente";
  String colCarrera = "carrera";
  String colAsignatura = "asignatura";
  String colEstudiantes = "estudiantes";
  String colEstudiantesPresent = "estudiantespresent";
  String colUnidad = "unidad";
  String colEvaluacion = "evaluacion";
  String colObservaciones = "observaciones";

  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}report_list2.db";
    final reportListDB =
        await openDatabase(path, version: 16, onCreate: _createDb2);
    return reportListDB;
  }

  void _createDb2(Database db, int version) async {
    await db.execute("""CREATE TABLE $reportTable(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $colWeek TEXT, 
          $colDate TEXT, 
          $colSede TEXT, 
          $colDocente TEXT, 
          $colCarrera TEXT,
          $colAsignatura TEXT,
          $colEstudiantes TEXT,
          $colEstudiantesPresent TEXT,
          $colUnidad,
          $colEvaluacion TEXT,
          $colObservaciones TEXT
          )""");
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(reportTable);
    return result;
  }

  Future<List<Report>> getNoteList() async {
    final List<Map<String, dynamic>> reportMapList = await getNoteMapList();

    final List<Report> reportList = [];

    for (var reportMap in reportMapList) {
      reportList.add(Report.fromMap(reportMap));
    }
    reportList
        .sort((reportA, reportB) => reportA.date!.compareTo(reportB.date!));
    return reportList;
  }

  Future<int> insertReport(Report report) async {
    Database? db = await this.db;
    final int result = await db!.insert(reportTable, report.toMap());
    return result;
  }

  Future<int> updateReport(Report report) async {
    Database? db = await this.db;
    final int result = await db!.update(reportTable, report.toMap(),
        where: "$colId = ?", whereArgs: [report.id]);
    return result;
  }

  Future<int> deleteReport(int id) async {
    Database? db = await this.db;
    final int result =
        await db!.delete(reportTable, where: "$colId = ?", whereArgs: [id]);
    return result;
  }
}
