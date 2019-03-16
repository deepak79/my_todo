import 'dart:async';
import 'dart:io';

import 'package:my_todo/models/todo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String todoTbl = 'todotable';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colIsDone = 'isDone';
  String colColor = 'color';
  String colCreatedAt = 'createdAt';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'todo.db');
    // Open/create the database at a given path
    var todoDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $todoTbl($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colDate INTEGER, $colIsDone TEXT, $colColor INTEGER,$colCreatedAt INTEGER)');
  }

  // Fetch Operation: Get all Todo objects from database
  Future<List<Map<String, dynamic>>> getAllTodo(String choice) async {
    Database db = await this.database;
    var result;
    if (choice == "All") {
      result = await db.query(todoTbl);
    } else if (choice == "Done") {
      result =
          await db.rawQuery("SELECT * FROM $todoTbl WHERE $colIsDone = 'Done'");
    }  else if (choice == "With reminder") {
      result = await db
          .rawQuery("SELECT * FROM $todoTbl WHERE $colDate IS NOT NULL");
    } else if (choice == "Without reminder") {
      result =
          await db.rawQuery("SELECT * FROM $todoTbl WHERE $colDate IS NULL");
    } else {
      result = await db.query(todoTbl);
    }

    return result;
  }

  // Insert Operation: Insert a Todo object to database
  Future<int> insertTodo(Todo todo) async {
    Database db = await this.database;
    var result = await db.insert(todoTbl, todo.toMap());
    return result;
  }

  // Update Operation: Update a Todo object and save it to database
  Future<int> updateTodo(Todo todo) async {
    var db = await this.database;
    var result = await db.update(todoTbl, todo.toMap(),
        where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }

  // Delete Operation: Delete a Todo object from database
  Future<int> deleteTodo(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $todoTbl WHERE $colId = $id');
    return result;
  }

  // Get number of Todo objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $todoTbl');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Todo List' [ List<Todo> ]
  Future<List<Todo>> getAllTodos(String choice) async {
    var todoList = await getAllTodo(choice); // Get 'Map List' from database
    int count = todoList.length; // Count the number of map entries in db table

    List<Todo> todoLists = List<Todo>();
    // For loop to create a 'Todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoLists.add(Todo.fromMapObject(todoList[i]));
    }

    return todoLists;
  }
}
