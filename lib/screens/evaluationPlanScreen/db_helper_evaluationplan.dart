import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperEvaluationPlan {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE thesevaluation(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     period TEXT,
     career TEXT,
     subject TEXT,
     section TEXT,
     semester TEXT,
     objective TEXT,
     content TEXT,
     date TEXT,
     assessment TEXT
    )
     """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_evaluation.db',
      version: 11,
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
      String objective,
      String content,
      String date,
      String assessment) async {
    final db = await DBHelperEvaluationPlan.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester,
      'objective': objective,
      'content': content,
      'date': date,
      'assessment': assessment
    };
    final id = await db.insert('thesevaluation', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperEvaluationPlan.db();
    return db.query('thesevaluation', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getsingleDataStudenstList(
      String period,
      String career,
      String subject,
      String section,
      String semester) async {
    final db = await DBHelperEvaluationPlan.db();
    return db.query(
      'thesevaluation',
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
      String objective,
      String content,
      String date,
      String assessment) async {
    final db = await DBHelperEvaluationPlan.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester,
      'objective': objective,
      'content': content,
      'date': date,
      'assessment': assessment
    };

    final result = await db
        .update('thesevaluation', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperEvaluationPlan.db();
    try {
      await db.delete("thesevaluation", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
