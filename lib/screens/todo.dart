import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('toDo'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('ToDo name', style: Theme.of(context).textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500)
                  ),
                  Text(selectedTodo['name'], style: Theme.of(context).textTheme.bodyMedium!
                    .copyWith(fontSize: 22),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text('ToDo Description', style: Theme.of(context).textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500)
                  ),
                  Text(selectedTodo['description'], style: Theme.of(context).textTheme.bodyMedium!
                    .copyWith(fontSize: 22),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text('ToDo Description', style: Theme.of(context).textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500)
                  ),
                  Text(selectedTodo['description'], style: Theme.of(context).textTheme.bodyMedium!
                    .copyWith(fontSize: 22),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text('ToDo Description', style: Theme.of(context).textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500)
                  ),
                  Text(selectedTodo['description'], style: Theme.of(context).textTheme.bodyMedium!
                    .copyWith(fontSize: 22),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: ElevatedButton(
                      style: selectedTodo['complited'] 
                        ? ElevatedButton.styleFrom(primary: customColors.yellow)
                        : ElevatedButton.styleFrom(primary: customColors.green),
                      onPressed: () => {}, 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_alarm_outlined, color: Colors.black, size: 32,),
                          SizedBox(width: 8), 
                          selectedTodo['complited'] 
                          ? Text('to work', style: TextStyle(color: Colors.black, fontSize: 22))
                          : Text('to complite', style: TextStyle(color: Colors.black, fontSize: 22))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Flexible(
            child: Column(
              children: [
                Text('Logs', style: Theme.of(context).textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w500)
                ),
                const SizedBox(height: 8),
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
                      return ListView.separated(
                        itemCount: snapshot.data!.docs.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          final log = snapshot.data!.docs[index];
                          Timestamp time = log['time']as Timestamp;
                          DateTime date = time.toDate();
                          return ListTile(
                            tileColor: Color.fromARGB(0, 119, 21, 21),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(log['sender']),
                                Text(log['message']),
                                Text('$date'),
                              ],
                            ),
                            contentPadding: const EdgeInsets.only(left: 8),
                            onTap: () {},
                          );
                        }, 
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 10,
                            thickness: 2,
                            indent: 0,
                            endIndent: 73,
                            color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}