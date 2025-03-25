class Todo {
  final int? id;
  final String todo;

  Todo({this.id, required this.todo});

  Map<String, dynamic> toMap() {
    return {'id': id, 'todo': todo};
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      todo: map['todo'],
    );
  }
}