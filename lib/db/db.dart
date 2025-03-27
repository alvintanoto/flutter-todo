import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');

    return await openDatabase(path, version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo (
        id INTEGER PRIMARY KEY,
        todo TEXT,
        isDone INTEGER
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
        ALTER TABLE todo ADD COLUMN isDone INTEGER;
      ''');
    await db.execute('''
        UPDATE todo SET isDone = 0;
      ''');
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await instance.db;
    return await db.insert('todo', todo.toMap());
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await instance.db;
    return await db.update('todo', todo.toMap(), where: 'id=?', whereArgs: [todo.id]);
  }

  Future<List<Map<String, dynamic>>> getTodoList() async {
    Database db = await instance.db;
    return await db.query('todo', orderBy: 'isDone ASC, id DESC');
  }
}