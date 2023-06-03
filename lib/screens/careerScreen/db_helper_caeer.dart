import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperNewCareer {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE thenewcareer(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     career TEXT,
     period TEXT,
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_new_career.db',
      version: 6,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createData(String career, String period) async {
    final db = await DBHelperNewCareer.db();

    final data = {'career': career, 'period': period};
    final id = await db.insert('thenewcareer', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperNewCareer.db();
    return db.query('thecareer', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getsingleDataPeriod(
      String period) async {
    final db = await DBHelperNewCareer.db();
    return db.query('thenewcareer', where: "period = ?", whereArgs: [period]);
  }

  static Future<List<Map<String, dynamic>>> getsingleData(int id) async {
    final db = await DBHelperNewCareer.db();
    return db.query('thecareer', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String career, String period) async {
    final db = await DBHelperNewCareer.db();

    final data = {
      'career': career,
      'period': period,
    };

    final result =
        await db.update('thenewcareer', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperNewCareer.db();
    try {
      await db.delete("thenewcareer", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

/*import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperCareer {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE thecareer(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     career TEXT,

     createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_career.db',
      version: 3,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createData(String career) async {
    final db = await DBHelperCareer.db();

    final data = {'career': career};
    final id = await db.insert('thecareer', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperCareer.db();
    return db.query('thecareer', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getsingleDataPeriod(
      String period) async {
    final db = await DBHelperCareer.db();
    return db.query('thecareer', where: "period = ?", whereArgs: [period]);
  }

  static Future<List<Map<String, dynamic>>> getsingleData(int id) async {
    final db = await DBHelperCareer.db();
    return db.query('thecareer', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String career) async {
    final db = await DBHelperCareer.db();

    final data = {'career': career, 'createdAt': DateTime.now().toString()};

    final result =
        await db.update('thecareer', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperCareer.db();
    try {
      await db.delete("thecareer", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}*/
