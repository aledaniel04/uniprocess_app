import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperSubject {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE thesubject(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     period TEXT,
     career TEXT,
     subject TEXT,
     section TEXT,
     semester TEXT
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_subject.db',
      version: 3,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createData(String period, String career, String subject,
      String section, String semester) async {
    final db = await DBHelperSubject.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester
    };
    final id = await db.insert('thesubject', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperSubject.db();
    return db.query('thesubject', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getsingleDataCareer(
      String period, String career) async {
    final db = await DBHelperSubject.db();
    return db.query('thesubject',
        where: "period = ? AND career = ?", whereArgs: [period, career]);
  }

  static Future<List<Map<String, dynamic>>> getsingleData(int id) async {
    final db = await DBHelperSubject.db();
    return db.query('thesubject', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String period, String career,
      String subject, String section, String semester) async {
    final db = await DBHelperSubject.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester
    };

    final result =
        await db.update('thesubject', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperSubject.db();
    try {
      await db.delete("thesubject", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
