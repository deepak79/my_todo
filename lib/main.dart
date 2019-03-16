import 'package:flutter/material.dart';
import 'package:my_todo/models/mainmodel.dart';
import 'package:my_todo/pages/home.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> custom =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
            .animate(animation);
    if (settings.isInitialRoute) return child;
    return SlideTransition(position: custom, child: child);
  }
}
class MyApp extends StatelessWidget {
  final TodoModel todoModel =  TodoModel();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<TodoModel>(
      model:todoModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minimal To Do',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MyCustomRoute(
                builder: (_) => HomePage(),
                settings: settings,
              );
          }
          assert(false);
        },
      ),
    );
  }
}
