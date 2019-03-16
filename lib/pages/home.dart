import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_todo/models/mainmodel.dart';
import 'package:my_todo/pages/add_todomodal.dart';
import 'package:my_todo/pages/todo_row.dart';
import 'package:scoped_model/scoped_model.dart';

Widget showProgress() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

class HomePage extends StatelessWidget {
  final List<String> menu = [
    "All",
    "Done",
    "With reminder",
    "Without reminder"
  ];
  final int _radioValue1 = -1;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoModel>(
      builder: (context, child, model) {
        if (model.getSelectedMenu == "") {
          model.setSelectedMenu("All");
        }
        if (model.isChanged) {
          model.getTodoList(model.getSelectedMenu);
          model.isChanged = false;
        }
        return Scaffold(
          backgroundColor: Colors.grey[400].withOpacity(0.9),
          appBar: AppBar(
            title: Center(
              child: Text(
                'Minimal To Do',
                style: TextStyle(fontFamily: "Aller"),
              ),
            ),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == "All") {
                    model.setSelectedMenu("All");
                  } else if (val == "Done") {
                    model.setSelectedMenu("Done");
                  } else if (val == "With reminder") {
                    model.setSelectedMenu("With reminder");
                  } else if (val == "Without reminder") {
                    model.setSelectedMenu("Without reminder");
                  }
                },
                itemBuilder: (BuildContext context) {
                  return menu.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: model.getSelectedMenu == choice
                          ? Row(
                              children: <Widget>[
                                Radio(
                                  onChanged: (bool) {
                                    model.setSelectedMenu(choice);
                                  },
                                  groupValue: choice,
                                  value: choice,
                                ),
                                Text(choice)
                              ],
                            )
                          : Row(
                              children: <Widget>[
                                Radio(
                                  onChanged: (bool) {
                                    model.setSelectedMenu(choice);
                                  },
                                  groupValue: choice,
                                  value: 0,
                                ),
                                Text(choice)
                              ],
                            ),
                    );
                  }).toList();
                },
              )
            ],
          ),
          floatingActionButton: Builder(
            builder: (BuildContext c) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0)), //this right here
                              child: Container(
                                height: 250.0,
                                width: 300.0,
                                child: AddTodoModal(),
                              ),
                            ));
                  },
                  child: Icon(Icons.add),
                ),
              );
            },
          ),
          body: model.todoList == null ? showProgress() : check(model),
        );
      },
    );
  }

  Widget check(TodoModel model) {
    if (model.todoList.length == 0) {
      return Center(
        child: Text(
          'No todos',
          style: TextStyle(fontFamily: "Aller", fontSize: 30),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: model.todoList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: ToDoRow(
              position: index,
            ),
          );
        },
      );
    }
  }
}
