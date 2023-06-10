import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelperUser {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE theuser(
     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     grado TEXT,
     nombre TEXT,
     apellido TEXT,
     correo TEXT,
     telefono TEXT
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'database_user.db',
      version: 16,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createData(String grado, String nombre, String apellido,
      String correo, String telefono) async {
    final db = await DBHelperUser.db();

    final data = {
      'grado': grado,
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'telefono': telefono
    };
    final id = await db.insert('theuser', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelperUser.db();
    return db.query('theuser', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getsingleDataCareer(
      String period, String career) async {
    final db = await DBHelperUser.db();
    return db.query('theuser',
        where: "grado = ? AND nombre = ?", whereArgs: [period, career]);
  }

  static Future<List<Map<String, dynamic>>> getsingleData(int id) async {
    final db = await DBHelperUser.db();
    return db.query('theuser', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String grado, String nombre,
      String apellido, String correo, String telefono) async {
    final db = await DBHelperUser.db();

    final data = {
      'grado': grado,
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'telefono': telefono
    };

    final result =
        await db.update('theuser', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBHelperUser.db();
    try {
      await db.delete("theuser", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
