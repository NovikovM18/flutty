import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../utils/vars.dart';

class ToDo extends StatefulWidget {
  ToDo({super.key, required this.todoId});
  String todoId;

  @override
  State<ToDo> createState() => _ToDoState(todoId);
}

class _ToDoState extends State<ToDo> {
  String todoId;
  _ToDoState(this.todoId);
  final user = FirebaseAuth.instance.currentUser;
  final textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool loading = true;
  dynamic selectedTodo;
  
  getTodo() {
    setState(() {
      loading = true;
    });
    FirebaseFirestore.instance.collection('todos').doc(todoId).get()
      .then(
        (DocumentSnapshot doc) {
          setState(() {
            selectedTodo = doc.data() as Map<String, dynamic>;
            loading = false;
          });
        },
      onError: (e) => {
        setState(() {
          loading = false;
        })
      },
    );
  }

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
    final ref = FirebaseFirestore.instance.collection('todos/$todoId/logs');
    await ref.doc(DateTime.now().millisecondsSinceEpoch.toString() + user!.uid.toString()).set(log);
    textController.text = '';
    Timer(const Duration(milliseconds: 500), () => scrollToTheEnd());
  }

  Future updateToDo() async {
    final ref = FirebaseFirestore.instance.collection('todos').doc(todoId);
    await ref.update({'complited': !selectedTodo['complited']}).then(
      (v) => {
        setState(() {
          selectedTodo['complited'] = !selectedTodo['complited'];
        })
      },
      onError: (e) => {
        showDialog(context: context, builder: (context) => 
          AlertDialog(
            title: Text(e.code),
          )
        ),
      }
    );
  }

  @override
    void initState() {
    super.initState();
    getTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('toDo'),
        centerTitle: true,
      ),
      body: loading
      ? const Center(child: CircularProgressIndicator())
      : PageView(
        scrollDirection: Axis.horizontal,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                  child: ElevatedButton(
                    style: selectedTodo['complited'] 
                      ? ElevatedButton.styleFrom(
                          primary: customColors.yellow,
                          fixedSize: const Size(200, 60)
                        )
                      : ElevatedButton.styleFrom(
                          primary: customColors.green,
                          fixedSize: const Size(200, 60)
                        ),
                    onPressed: updateToDo, 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_alarm_outlined, 
                          color: Colors.black, size: 32
                        ),
                        const SizedBox(width: 8), 
                        selectedTodo['complited'] 
                        ? const Text('to work', style: TextStyle(color: Colors.black, fontSize: 22))
                        : const Text('to complite', style: TextStyle(color: Colors.black, fontSize: 22))
                      ],
                    ),
                  ),
                ),

                Text(selectedTodo.toString())
              ],
            ),
          ),
      
          Column(
            children: [
              Text('Logs', style: Theme.of(context).textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.w500)
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder(
                  stream: 
                    FirebaseFirestore.instance.collection('todos/$todoId/logs')
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
                          indent: 16,
                          endIndent: 16,
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
        ]
      ),
    );
  }
}