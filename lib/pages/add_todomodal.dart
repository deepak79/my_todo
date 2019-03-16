import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_todo/models/mainmodel.dart';
import 'package:my_todo/models/todo.dart';
import 'package:my_todo/ui_utils/bottomsheet_switch.dart';
import 'package:my_todo/utils/constants.dart';
import 'package:random_color/random_color.dart';
import 'package:scoped_model/scoped_model.dart';

class AddTodoModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTodoModalState();
}

class _AddTodoModalState extends State<AddTodoModal> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isRemindMe = false;
  DateTime selectedDateTime;
  bool isChangedOnUpdate = false;
  static const EdgeInsetsGeometry commanPadding =
      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0);

  _showDateTimePicker(TodoModel todoModel) {
    DatePicker.showDateTimePicker(context, showTitleActions: true,
        onChanged: (date) {
      if (date.difference(DateTime.now()).inSeconds > 0) {
        selectedDateTime = date;
        isChangedOnUpdate = true;
        todoModel.setDateStr(format.format(selectedDateTime));
      }
    }, onConfirm: (date) {
      selectedDateTime = date;
      isChangedOnUpdate = true;
      todoModel.setDateStr(format.format(selectedDateTime));
    },
        currentTime:
            selectedDateTime != null ? selectedDateTime : DateTime.now(),
        locale: LocaleType.en);
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var ios = new IOSInitializationSettings();
    var initializationSettings =
        new InitializationSettings(initializationSettingsAndroid, ios);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _titleController = new TextEditingController();
    _descriptionController = new TextEditingController();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void scheduleNotification(
      String title, String body, DateTime dateTime) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0, title, body, dateTime, platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoModel>(
      builder: (context, child, model) {
        if (model.getCurrentPosition != -1)
          _titleController.text =
              model.todoList[model.getCurrentPosition].title;

        if (model.getCurrentPosition != -1)
          _descriptionController.text =
              model.todoList[model.getCurrentPosition].description;

        if (model.getCurrentPosition != -1 &&
            model.todoList[model.getCurrentPosition].date != null) {
          if (!isChangedOnUpdate) {
            selectedDateTime = DateTime.fromMillisecondsSinceEpoch(
                model.todoList[model.getCurrentPosition].date);
            model.setDateStr(format.format(selectedDateTime));
          }
          isRemindMe = true;
        }
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: commanPadding,
                    child: TextFormField(
                      validator: (String val) {
                        if (val.isEmpty) {
                          return 'Please enter title';
                        }
                      },
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                      ),
                      style:
                          TextStyle(color: Colors.black, fontFamily: "Aller"),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: commanPadding,
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description',
                      ),
                      style:
                          TextStyle(color: Colors.black, fontFamily: "Aller"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              if (isRemindMe) _showDateTimePicker(model);
                            },
                            child: Image.asset(
                              'assets/images/remindme.png',
                              width: 35,
                              height: 35,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Remind me',
                            style: TextStyle(
                                fontFamily: "Aller",
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BottomSheetSwitch(
                            switchValue: isRemindMe,
                            valueChanged: (value) {
                              if (value) {
                                _showDateTimePicker(model);
                              }
                              setState(() {
                                isRemindMe = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                model.getDateStr != "" && isRemindMe
                    ? Flexible(
                        child: Padding(
                          padding: commanPadding,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Reminder set on ' + model.getDateStr,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Aller"),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Flexible(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text(
                              'Close',
                              style: TextStyle(fontFamily: "Aller"),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                if (model.getCurrentPosition == -1) {
                                  if (selectedDateTime != null) {
                                    scheduleNotification(
                                        _titleController.text,
                                        _descriptionController.text,
                                        selectedDateTime);
                                  }
                                  model.addTodo(
                                    Todo(
                                        title: _titleController.text,
                                        description:
                                            _descriptionController.text,
                                        date: selectedDateTime != null
                                            ? selectedDateTime
                                                .millisecondsSinceEpoch
                                            : null,
                                        isDone: "False",
                                        color:
                                            RandomColor().randomColor().value,
                                        createdAt: DateTime.now()
                                            .millisecondsSinceEpoch),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  if (selectedDateTime != null) {
                                    scheduleNotification(
                                        _titleController.text,
                                        _descriptionController.text,
                                        selectedDateTime);
                                  }
                                  model.todoList[model.getCurrentPosition]
                                      .title = _titleController.text;
                                  model.todoList[model.getCurrentPosition]
                                          .description =
                                      _descriptionController.text;
                                  model.todoList[model.getCurrentPosition]
                                      .date = selectedDateTime !=
                                          null
                                      ? selectedDateTime.millisecondsSinceEpoch
                                      : null;

                                  model.update(
                                      model.todoList[model.getCurrentPosition]);
                                  Navigator.pop(context);
                                }
                              }
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text(
                              model.getCurrentPosition != -1 ? 'Update' : 'Add',
                              style: TextStyle(fontFamily: "Aller"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
