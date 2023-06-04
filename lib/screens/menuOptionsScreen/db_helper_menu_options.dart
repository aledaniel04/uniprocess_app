import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperMenuOptions {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE themenu(
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
      'database_menu.db',
      version: 4,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createData(String period, String career, String subject,
      String section, String semester) async {
    final db = await DBHelperMenuOptions.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester
    };
    final id = await db.insert('themenu', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperMenuOptions.db();
    return db.query('themenu', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getsingleDataMenu(String period,
      String career, String subject, String section, String semester) async {
    final db = await DBHelperMenuOptions.db();
    return db.query(
      'themenu',
      where:
          "period = ? AND career = ? AND subject = ? AND section = ? AND semester = ?",
      whereArgs: [period, career, subject, section, semester],
    );
  }

  static Future<List<Map<String, dynamic>>> getsingleData(int id) async {
    final db = await DBHelperMenuOptions.db();
    return db.query('themenu', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String period, String career,
      String subject, String section, String semester) async {
    final db = await DBHelperMenuOptions.db();

    final data = {
      'period': period,
      'career': career,
      'subject': subject,
      'section': section,
      'semester': semester
    };

    final result =
        await db.update('themenu', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperMenuOptions.db();
    try {
      await db.delete("themenu", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
