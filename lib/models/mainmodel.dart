import 'package:my_todo/models/todo.dart';
import 'package:my_todo/ui_utils/database_helper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';

class TodoModel extends Model {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Todo> todoList;
  int _currentPosition = -1;
  bool isChanged = true;
  String _dateStr = "";
  String _selectedMenu = "";

  void setSelectedMenu(String selectedMenu) {
    this._selectedMenu = selectedMenu;
    getTodoList(selectedMenu);
    notifyListeners();
  }

  String get getSelectedMenu => _selectedMenu;

  void setDateStr(String dateStr) {
    this._dateStr = dateStr;
    notifyListeners();
  }

  String get getDateStr => _dateStr;

  void setCurrentPosition(int currentPosition) {
    this._currentPosition = currentPosition;
    notifyListeners();
  }

  int get getCurrentPosition => _currentPosition;

  void getTodoList(String choice) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((_) {
      databaseHelper.getAllTodos(choice).then((List<Todo> list) {
        this.todoList = list;
        notifyListeners();
      });
    });
  }

  void addTodo(Todo todo) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((_) {
      Future<int> insertFuture = databaseHelper.insertTodo(todo);
      insertFuture.then((_) {
        isChanged = true;
        notifyListeners();
      });
    });
  }

  void delete(int id) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((_) {
      Future<int> insertFuture = databaseHelper.deleteTodo(id);
      insertFuture.then((_) {
        isChanged = true;
        notifyListeners();
      });
    });
  }

  void update(Todo todo) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((_) {
      Future<int> insertFuture = databaseHelper.updateTodo(todo);
      insertFuture.then((_) {
        isChanged = true;
        _currentPosition = -1;
        notifyListeners();
      });
    });
  }
}
