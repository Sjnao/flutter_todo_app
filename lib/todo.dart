
final String tableTodo = 'todo';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';
final String columnCreatedAt = 'createdAt';
final String columnDoneAt = 'doneAt';
final String columnPriority = 'priority';

enum Priority {low, medium, height}

class Todo {
  int id;
  String title;
  bool done;
  DateTime createdAt = DateTime.now();
  DateTime doneAt;
  Priority priority = Priority.medium;


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0,
      columnCreatedAt: createdAt.toString(),
      columnPriority: priority.toString()
    };
    if (id != null) {
      map[columnId] = id;
    }
    if (doneAt != null) {
      map[columnDoneAt] = doneAt.toString();
    }
    return map;
  }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    print(map);
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
    createdAt = DateTime.parse(map[columnCreatedAt]);
    doneAt = map[columnDoneAt] != null ? DateTime.parse(map[columnDoneAt]) : null;
    priority =  map[columnPriority] != null ? Priority.values.firstWhere((e) => e.toString() == map[columnPriority]) : Priority.medium;
  }
}

