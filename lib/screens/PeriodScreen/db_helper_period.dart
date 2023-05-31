import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperCareer {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE theperiod(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     period TEXT,
     createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_period.db',
      version: 2,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createData(String period) async {
    final db = await DBHelperCareer.db();

    final data = {'period': period};
    final id = await db.insert('theperiod', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperCareer.db();
    return db.query('theperiod', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getsingleData(
      int id, String period) async {
    final db = await DBHelperCareer.db();
    return db.query('theperiod', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String period) async {
    final db = await DBHelperCareer.db();

    final data = {'period': period, 'createdAt': DateTime.now().toString()};

    final result =
        await db.update('theperiod', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperCareer.db();
    try {
      await db.delete("theperiod", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
