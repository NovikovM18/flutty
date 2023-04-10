import 'package:flutter/material.dart';

class ToDo extends StatefulWidget {
  ToDo({super.key, required this.selectedTodo});
  dynamic selectedTodo;
  
  @override
  State<ToDo> createState() => _ToDoState(selectedTodo);
}

class _ToDoState extends State<ToDo> {
  dynamic selectedTodo;
  _ToDoState(this.selectedTodo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('toDo'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectedTodo['name'], 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            Text(selectedTodo['description'],
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}