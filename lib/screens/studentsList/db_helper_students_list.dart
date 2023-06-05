import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperStudentsList {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE thestudentslist(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     period TEXT,
     career TEXT,
     subject TEXT,
     section TEXT,
     semester TEXT,
     name TEXT,
     lastname TEXT,
     cedula TEXT
    )
     """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_studentslist.db',
      version: 5,
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
      String name,
      String lastname,
      String cedula) async {
    final db = await DBHelperStudentsList.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester,
      'name': name,
      'lastname': lastname,
      'cedula': cedula
    };
    final id = await db.insert('thestudentslist', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperStudentsList.db();
    return db.query('thestudentslist', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getsingleDataStudenstList(
      String period,
      String career,
      String subject,
      String section,
      String semester) async {
    final db = await DBHelperStudentsList.db();
    return db.query(
      'thestudentslist',
      where:
          "period = ? AND career = ? AND subject = ? AND section = ? AND semester = ?",
      whereArgs: [period, career, subject, section, semester],
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
      String name,
      String lastname,
      String cedula) async {
    final db = await DBHelperStudentsList.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester,
      'name': name,
      'lastname': lastname,
      'cedula': cedula
    };

    final result = await db
        .update('thestudentslist', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperStudentsList.db();
    try {
      await db.delete("thestudentslist", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
