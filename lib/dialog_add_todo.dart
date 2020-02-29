import 'package:flutter/material.dart';
import 'package:todo_app/todo.dart';
import 'package:todo_app/db_helper.dart';

class DialogAddTodo extends StatefulWidget {
  @override
  _DialogAddTodoState createState() => new _DialogAddTodoState();
}

class _DialogAddTodoState extends State<DialogAddTodo> {
  TodoProvider todoProvider = TodoProvider();
  final addTaskController = TextEditingController();
  Priority priority = Priority.medium;
  var items = <Priority>[
    Priority.low,
    Priority.medium,
    Priority.height
  ];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Task"),
      content:
      StatefulBuilder(builder: (context, state) {


        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: addTaskController,
              decoration: InputDecoration(hintText: "Task"),
            ),
            Row(
              children: <Widget>[
                Text("Priority: "),
                Spacer(),
                DropdownButton<Priority>(
                    value: priority,
                    onChanged: (Priority p) {
                      setState(() {
                        print(p);
                        priority = p;
                      });
                    },
                    items: items.map((Priority p) {
                      switch (p) {
                        case Priority.low:
                          return DropdownMenuItem<Priority>(
                              value: p, child: Text('low'));
                        case Priority.medium:
                          return DropdownMenuItem<Priority>(
                              value: p, child: Text('medium'));
                        case Priority.height:
                          return DropdownMenuItem<Priority>(
                              value: p, child: Text('height'));
                        default:
                          return DropdownMenuItem<Priority>(
                              value: p, child: Text(p.toString()));
                      }
                    }).toList()),
              ],
            )
          ],
        );
      }),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Ok'),
          onPressed: () {
            setState(() {
              var todo = Todo();
              todo.title = addTaskController.text;
              todo.done = false;
              todo.createdAt = DateTime.now();
              todo.priority = priority;
              todoProvider.insert(todo);
              addTaskController.text = '';
            });
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}