import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_todo/models/mainmodel.dart';
import 'package:my_todo/pages/add_todomodal.dart';
import 'package:my_todo/utils/constants.dart';
import 'package:scoped_model/scoped_model.dart';

class ToDoRow extends StatelessWidget {
  final int position;

  ToDoRow({this.position});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoModel>(
      builder: (context, child, model) {
        return Slidable(
          delegate: SlidableDrawerDelegate(),
          actionExtentRatio: 0.25,
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                if (model.todoList[position].getIsDone != "Done") {
                  model.setCurrentPosition(position);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Container(
                            height: 250.0,
                            width: 300.0,
                            child: AddTodoModal(),
                          ),
                        ),
                  ).then((val) {
                    model.setCurrentPosition(-1);
                  });
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      content: Container(
                        height: 20,
                        child: Center(
                          child: Text(
                            'Todo is already done!',
                            style: TextStyle(
                                fontFamily: 'Aller',
                                fontSize: 20,
                                color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Color(model.todoList[position].color),
                      child: Text(
                        "T",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: ListTile(
                      title: Text(
                        model.todoList[position].title,
                        style: TextStyle(
                          decoration: model.todoList[position].isDone == "Done"
                              ? TextDecoration.lineThrough
                              : null,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Aller",
                          letterSpacing: 0.5,
                        ),
                      ),
                      subtitle: Text(
                        model.todoList[position].date != null
                            ? "Reminder at : " +
                                format.format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        model.todoList[position].date))
                            : "No reminder",
                        style: TextStyle(
                            decoration:
                                model.todoList[position].isDone == "Done"
                                    ? TextDecoration.lineThrough
                                    : null,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[800],
                            letterSpacing: 1,
                            fontFamily: "Aller"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Done',
              color: model.todoList[position].isDone != "Done"
                  ? Colors.green
                  : Colors.grey,
              icon: Icons.done_outline,
              onTap: () {
                if (model.todoList[position].isDone != "Done") {
                  model.todoList[position].isDone = "Done";
                  model.update(model.todoList[position]);
                }
              },
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                model.delete(model.todoList[position].getid);
              },
            ),
          ],
        );
      },
    );
  }
}
