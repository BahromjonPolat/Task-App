import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:storage/models/task_model.dart';

class DatabaseHelper {
  static DatabaseHelper? databaseHelper;
  static Database? database;

  DatabaseHelper.internal();

  /// CONSTRUCTOR.
  factory DatabaseHelper() {
    return databaseHelper ?? DatabaseHelper.internal();
  }

  /// 1. ON CREATE METODI OCHILADI. PARAMETRIGA DATABASE VA VERSION OLADI.
  /// UNING ICHIDA QUERY YOZILADI
  _onCreateTable(Database db, int version) async {
    String query =
        "CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, subtitle TEXT, priority TEXT, imageUrl TEXT)";
    await db.execute(query);
  }

  /// 2. INIT DATABASE METODI YOZILADI. UNDA PATH TANITILIB QIYMAT BERILADI.
  /// openDatabase() FUNKSIYASI ORQALI MA'LUMOTLAR BAZASI OCHILADI
  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String pathDb = path.join(directory.path, "tasks.db");

    var openDb =
        await openDatabase(pathDb, version: 1, onCreate: _onCreateTable);
    return openDb;
  }

  /// 3. MA'LUMOTLAR BAZASINI OLISH. AGAR MA''LUMOTLAR BAZASI AVVAL OCHILGAN
  /// BO'LSA, database RETUTN QILINADI, AKS HOLDA _initDatabase() RETURN QILINADI.
  Future<Database> _getDatabase() async {
    return database ?? await _initDatabase();
  }

  Future<int> addTask(Task task) async {
    Database db = await _getDatabase();
    var result = db.insert("tasks", task.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    Database db = await _getDatabase();
    var result = db.query('tasks');
    db.close();
    result.then((value) => print(value));
    return result;
  }

  Future updateTask(Task task) async {
    Database db = await _getDatabase();
    db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future deleteTAsk(int id) async {
    Database db = await _getDatabase();
    db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    db.close();
  }
}
