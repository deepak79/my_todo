import 'package:flutter/material.dart';

class Todo {
  int id;
  String title;
  String description;
  int date;
  String isDone;
  int color;
  int createdAt;

  Todo(
      {@required this.title,
      @required this.description,
      @required this.date,
      @required this.isDone,
      @required this.color,
      @required this.createdAt});

  int get getid => id;

  String get gettitle => title;

  String get getdescription => description;

  int get getdate => date;

  String get getIsDone => isDone;

  int get getColor => color;


  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['date'] = date;
    map['isDone'] = isDone;
    map['color'] = color;
    map['createdAt'] = createdAt;
    return map;
  }

  // Extract a Note object from a Map object
  Todo.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.date = map['date'];
    this.isDone = map['isDone'];
    this.color = map['color'];
    this.createdAt = map['createdAt'];
  }
}
