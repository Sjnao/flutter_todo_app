import 'package:flutter/material.dart';
import 'package:todo_app/db_helper.dart';
import 'package:todo_app/todo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TodoProvider todoProvider = TodoProvider();

  List<Todo> todoTasks;
  List<Todo> doneTasks;
  final addTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (todoTasks == null && doneTasks == null) {
      updateLists();
      return Center(
          child: SpinKitRotatingCircle(
            color: Colors.blueAccent,
            size: 50.0,
          ));
    }
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red[900], Colors.deepOrange])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SafeArea(
                    child: Text(
                      "TO-DO",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 32),
                    )),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: todoTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (todoTasks.isEmpty) {
                          return Center(
                            child: Text("any to-do tasks yet!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                          );
                        }
                        return CheckboxListTile(
                          title: Row(
                            children: <Widget>[
                              Text(todoTasks[index].title,
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Padding(padding: const EdgeInsets.only(right: 16),
                              ),
                              Text(
                                  DateFormat('dd-MM-yyyy hh:mm').format(
                                      todoTasks[index].createdAt),
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          value: false,
                          onChanged: (bool value) {
                            var todo = todoTasks[index];
                            todo.done = true;
                            todo.doneAt = DateTime.now();
                            todoProvider
                                .update(todo)
                                .then((_) => this.updateLists());
                          },
                        );
                      })),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "DONE",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: doneTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (doneTasks.isEmpty) {
                          return Center(
                            child: Text("any done tasks yet!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                          );
                        }
                        return ListTile(
                            title: Row(
                              children: <Widget>[
                                Text(doneTasks[index].title,
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20,
                                        decoration: TextDecoration
                                            .lineThrough)),
                                Padding(padding: const EdgeInsets.only(
                                    right: 16),
                                ),
                                Text(
                                    DateFormat('dd-MM-yyyy hh:mm').format(
                                        doneTasks[index].doneAt),
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 16)),
                              ],
                            ));
                      })),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  Priority priority = Priority.medium;
                  var items = <Priority>[
                    Priority.low,
                    Priority.medium,
                    Priority.height
                  ].map((Priority p) {
                    switch (p) {
                      case Priority.low:
                        return DropdownMenuItem<Priority>(
                            value: p,
                            child: Text('low')
                        );
                      case Priority.medium:
                        return DropdownMenuItem<Priority>(
                            value: p,
                            child: Text('medium')
                        );
                      case Priority.height:
                        return DropdownMenuItem<Priority>(
                            value: p,
                            child: Text('height')
                        );
                      default:
                        return DropdownMenuItem<Priority>(
                            value: p,
                            child: Text(p.toString())
                        );
                    }
                  }).toList();
                  return AlertDialog(
                    title: Text("Add Task"),
                    content: Column(
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
                                items: items
                            ),
                          ],
                        )
                      ],
                    ),
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
                            updateLists();
                            addTaskController.text = '';
                          });
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          },
          child: Icon(Icons.add),
        ));
  }

  void updateLists() {
    this.todoTasks = List();
    this.doneTasks = List();

    todoProvider.getAllTodo(false).then((list) {
      setState(() {
        this.todoTasks = list;
      });
    });

    todoProvider.getAllTodo(true).then((list) {
      setState(() {
        doneTasks = list;
      });
    });
  }
}
