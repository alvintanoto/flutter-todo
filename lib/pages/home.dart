import 'package:flutter/material.dart';
import '../db/db.dart';
import '../models/todo.dart';

class HomeTodoList extends StatefulWidget {
  const HomeTodoList({super.key});

  @override
  State<HomeTodoList> createState() => _HomeTodoListState();
}

class _HomeTodoListState extends State<HomeTodoList> {
  List<Todo> _todoList = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchTodoData();
  }

  void _fetchTodoData() async {
    final todoMaps = await DatabaseHelper.instance.getTodoList();
    setState(() {
      _todoList = todoMaps.map((userMap) => Todo.fromMap(userMap)).toList();
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Todo App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, '/add').then((todo) {
              final returnedData = todo as Todo;
              setState(() {
                _todoList.insert(0, returnedData);
              });
            }),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), body: _todoList.isEmpty && !isLoaded ? const Center(
      child: CircularProgressIndicator(),
    ) : ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(_todoList[index].todo, style: _todoList[index].isDone == 1 ? TextStyle(decoration: TextDecoration.lineThrough): null,),
            value: _todoList[index].isDone == 0 ? false : true,
            onChanged: (value) async {
              if (_todoList[index].isDone == 0) {
                _todoList[index].isDone = 1;
              } else {
                _todoList[index].isDone = 0;
              }
              await DatabaseHelper.instance.updateTodo(_todoList[index]);

              setState(() {
                _fetchTodoData();
              });
            },
          );
        }),
    );
  }
}
