import 'package:flutter/material.dart';
import 'package:todo_app/db_helper.dart';
import 'package:todo_app/todo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SafeArea(
                  child:Text(
                "TO-DO",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: todoTasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (todoTasks.isEmpty) {
                        return Center(
                          child: Text("any to-do tasks yet!"),
                        );
                      }
                      return CheckboxListTile(
                        title: Text(todoTasks[index].title),
                        value: false,
                        onChanged: (bool value) {
                            var todo = todoTasks[index];
                            todo.done = true;
                            todo.doneAt = DateTime.now();
                            todoProvider.update(todo).then((_) => this.updateLists());
                        },
                      );
                    })),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "DONE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: doneTasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (doneTasks.isEmpty) {
                        return Center(
                          child: Text("any done tasks yet!"),
                        );
                      }
                      return ListTile(
                          title: Text(doneTasks[index].title,
                              style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough)));
                    })),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Add Task"),
                    content: TextField(
                      controller: addTaskController,
                      decoration: InputDecoration(hintText: "Task"),
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
