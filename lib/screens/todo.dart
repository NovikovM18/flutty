import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../utils/vars.dart';

class ToDo extends StatefulWidget {
  ToDo({super.key, required this.selectedTodo});
  dynamic selectedTodo;

  @override
  State<ToDo> createState() => _ToDoState(selectedTodo);
}

class _ToDoState extends State<ToDo> {
  dynamic selectedTodo;
  _ToDoState(this.selectedTodo);
  final user = FirebaseAuth.instance.currentUser;
  final textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  void scrollToTheEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent, 
      duration: const Duration(milliseconds: 224), 
      curve: Curves.ease
    );
  }
  Future<void> addLog() async {
    var log = {
      'sender': user!.uid,
      'message': textController.text,
      'time': DateTime.now(),
    };
    final ref = FirebaseFirestore.instance.collection('todos/${selectedTodo.id}/logs');
    await ref.doc(DateTime.now().millisecondsSinceEpoch.toString() + user!.uid.toString()).set(log);
    textController.text = '';
    Timer(const Duration(milliseconds: 500), () => scrollToTheEnd());
  }

  @override
    void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('toDo'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Text(selectedTodo['name']),
              const SizedBox(height: 12),
              Text(selectedTodo['description']),
              const SizedBox(height: 24),
              const Text('Logs:'),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: 
                FirebaseFirestore.instance.collection('todos/${selectedTodo.id}/logs')
                .orderBy('time')
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Text('no logs');
                }
                SchedulerBinding.instance.addPostFrameCallback((context) {
                  scrollToTheEnd();
                });
                return ListView.builder(
                  // physics: BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final log = snapshot.data!.docs[index];
                    Timestamp time = log['time']as Timestamp;
                    DateTime date = time.toDate();
                    return ListTile(
                      tileColor: const Color.fromARGB(0, 0, 0, 0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log['message']),
                          Text('$date'),
                        ],
                      ),
                      contentPadding: const EdgeInsets.only(left: 8),
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ),
          Card(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {},
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: mainFont,
                      fontSize: BodyTextSize
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Type Something...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8)
                    ),
                  )
                ),
                MaterialButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) addLog();
                  },
                  minWidth: 0,
                  padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                  shape: const CircleBorder(),
                  color: Colors.deepPurple,
                  child: const Icon(Icons.send, color: Colors.white, size: 22),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}