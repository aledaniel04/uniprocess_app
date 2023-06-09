import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperSchedule {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE theschedule(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     day TEXT,
     hour1 TEXT,
     hour2 TEXT,
     subject TEXT,
     classroom TEXT
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_schedule.db',
      version: 10,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createData(String day, String hour1, String hour2,
      String subject, String classroom) async {
    final db = await DBHelperSchedule.db();

    final data = {
      'day': day,
      'hour1': hour1,
      'hour2': hour2,
      'subject': subject,
      'classroom': classroom
    };
    final id = await db.insert('theschedule', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperSchedule.db();
    return db.query('theschedule', orderBy: "id");
  }

  /* static Future<List<Map<String, dynamic>>> getsingleDataCareer(
      String period, String career) async {
    final db = await DBHelperSchedule.db();
    return db.query('theschedule',
        where: "period = ? AND career = ?", whereArgs: [period, career]);
  }

  static Future<List<Map<String, dynamic>>> getsingleData(int id) async {
    final db = await DBHelperSchedule.db();
    return db.query('theschedule', where: "id = ?", whereArgs: [id], limit: 1);
  }*/

  static Future<int> updateData(int id, String day, String hour1, String hour2,
      String subject, String classroom) async {
    final db = await DBHelperSchedule.db();

    final data = {
      'day': day,
      'hour1': hour1,
      'hour2': hour2,
      'subject': subject,
      'classroom': classroom
    };

    final result =
        await db.update('theschedule', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperSchedule.db();
    try {
      await db.delete("theschedule", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
