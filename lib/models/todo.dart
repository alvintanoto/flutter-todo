class Todo {
  int? id;
  String todo;
  int isDone;

  Todo({this.id, required this.todo, required this.isDone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'todo': todo, 'isDone': isDone};
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    Todo todo = Todo(id: map['id'], todo: map['todo'], isDone: 0);
    if(map['isDone'] == 1) {
      todo.isDone = 1;
    }

    return todo;
  }
}
