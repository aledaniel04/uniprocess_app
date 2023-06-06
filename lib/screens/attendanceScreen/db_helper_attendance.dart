import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperAttendence {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE theattendance(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     period TEXT,
     career TEXT,
     subject TEXT,
     section TEXT,
     semester TEXT,
     idstudent INTEGER,
     date TEXT,
     assistance INTEGER
    )
     """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_attendance.db',
      version: 7,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createData(
      String period,
      String career,
      String subject,
      String section,
      String semester,
      int idstudent,
      String date,
      int assistance) async {
    final db = await DBHelperAttendence.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester,
      'idstudent': idstudent,
      'date': date,
      'assistance': assistance
    };
    final id = await db.insert('theattendance', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperAttendence.db();
    return db.query('theattendance', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getsingleDataAttendance(
    String period,
    String career,
    String subject,
    String section,
    String semester,
    String date,
  ) async {
    final db = await DBHelperAttendence.db();
    return db.query(
      'theattendance',
      where:
          "period = ? AND career = ? AND subject = ? AND section = ? AND semester = ? AND date = ?",
      whereArgs: [period, career, subject, section, semester, date],
    );
  }

  /*static Future<List<Map<String, dynamic>>> getsingleData(int id) async {
    final db = await DBHelperStudentsList.db();
    return db.query('themenu', where: "id = ?", whereArgs: [id], limit: 1);
  }*/

  static Future<int> updateData(
      int id,
      String period,
      String career,
      String subject,
      String section,
      String semester,
      int idstudent,
      String date,
      int assistance) async {
    final db = await DBHelperAttendence.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester,
      'idstudent': idstudent,
      'date': date,
      'assistance': assistance
    };

    final result = await db
        .update('theattendance', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperAttendence.db();
    try {
      await db.delete("thestudentslist", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
