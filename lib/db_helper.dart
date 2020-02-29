import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/todo.dart';

class DatabaseHelper {
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo.db';
    // https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md
   var db = await openDatabase(path, version: 5,
        onCreate: (Database db, int version) async {
      await db.execute('''
            create table $tableTodo ( 
              $columnId integer primary key autoincrement, 
              $columnTitle text not null,
              $columnDone integer not null,
              $columnCreatedAt text not null,
              $columnDoneAt text)
            ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
     print('upgranding database to: $newVersion');
         var batch = db.batch();
         switch (newVersion) {
           case 5:
             batch.execute('ALTER TABLE $tableTodo ADD $columnPriority TEXT');
             break;
           case 4:
             batch.execute('DELETE FROM $tableTodo');
         }
         await batch.commit();
       });
   return db;
  }
}

class TodoProvider extends DatabaseHelper{

  static TodoProvider _todoProvider;

  TodoProvider._createInstance();

  factory TodoProvider() {
    if (_todoProvider == null) {
      _todoProvider = TodoProvider._createInstance();
    }
    return _todoProvider;
  }

  Future<Todo> insert(Todo todo) async {
    var db = await this.database;
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    var db = await this.database;
    List<Map> maps = await db.query(tableTodo,
        columns: [
          columnId,
          columnDone,
          columnTitle,
          columnCreatedAt,
          columnDoneAt,
          columnPriority
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Todo>> getAllTodo(bool done) async {
    var db = await this.database;
    List<Todo> list = new List();
    List<Map> maps = await db.query(tableTodo,
        columns: [
          columnId,
          columnDone,
          columnTitle,
          columnCreatedAt,
          columnDoneAt,
          columnPriority
        ],
        where: '$columnDone = ?',
        whereArgs: [done ? 1 : 0]);

    maps.forEach((m) => list.add(Todo.fromMap(m)));

    return list;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    var db = await this.database;
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }
}
