import 'package:flutter/material.dart';
import 'package:todo_app/db_helper.dart';
import 'package:todo_app/todo.dart';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TodoProvider todoProvider = TodoProvider();

  List<Todo> todoTasks;
  List<Todo> doneTasks;
  int countTodoTasks = 0;
  int countDoneTasks = 0;
  final addTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (todoTasks == null && doneTasks == null) {
      updateLists();
    }
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: countTodoTasks,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return ListTile(
                          title: Text(
                            "TO-DO",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        );
                      }
                      return CheckboxListTile(
                        title: Text(todoTasks[index - 1].title),
                        value: false,
                        onChanged: (bool value) {
                          setState(() {
                            doneTasks.add(todoTasks[index - 1]);
                            todoTasks.removeAt(index - 1);
                          });
                        },
                      );
                    })),
            Expanded(
                child: ListView.builder(
                    itemCount: countDoneTasks,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return ListTile(
                          title: Text(
                            "DONE",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        );
                      }
                      return ListTile(
                          title: Text(
                              doneTasks[index - 1].title,
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
      todoProvider.getAllTodo(false)
          .then((list) {
        setState(() {
          this.todoTasks = list;
          this.countTodoTasks = todoTasks.length + 1;
        });
      });

      todoProvider.getAllTodo(true)
          .then((list) {
        setState(() {
          doneTasks = list;
          countDoneTasks = doneTasks.length + 1;
        });
      });
  }

}
