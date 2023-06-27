import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperQualification4 {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE thequalification4(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     period TEXT,
     career TEXT,
     subject TEXT,
     section TEXT,
     semester TEXT,
     idstudent INTEGER,
     name TEXT,
     lastname TEXT,
     cedula TEXT,
     evaluation TEXT,
     qualification TEXT,
     date TEXT
    )
     """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_qualification4.db',
      version: 25,
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
      String name,
      String lastname,
      String cedula,
      String evaluation,
      String qualification,
      String date) async {
    final db = await DBHelperQualification4.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester,
      'idstudent': idstudent,
      'name': name,
      'lastname': lastname,
      'cedula': cedula,
      'evaluation': evaluation,
      'qualification': qualification,
      'date': date
    };
    final id = await db.insert('thequalification4', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperQualification4.db();
    return db.query('thequalification4', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getsingleDataQualification(
    String period,
    String career,
    String subject,
    String section,
    String semester,
    int idstudent,
    String name,
    String lastname,
    String cedula,
  ) async {
    final db = await DBHelperQualification4.db();
    return db.query(
      'thequalification4',
      where:
          "period = ? AND career = ? AND subject = ? AND section = ? AND semester = ?  AND idstudent = ? AND name = ? AND lastname = ? AND cedula = ?",
      whereArgs: [
        period,
        career,
        subject,
        section,
        semester,
        idstudent,
        name,
        lastname,
        cedula
      ],
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
      String name,
      String lastname,
      String cedula,
      String evaluation,
      String qualification,
      String date) async {
    final db = await DBHelperQualification4.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester,
      'idstudent': idstudent,
      'name': name,
      'lastname': lastname,
      'cedula': cedula,
      'evaluation': evaluation,
      'qualification': qualification,
      'date': date
    };

    final result = await db
        .update('thequalification4', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperQualification4.db();
    try {
      await db.delete("thequalification4", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
