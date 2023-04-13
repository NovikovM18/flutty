import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutty/screens/todo.dart';

class ToDos extends StatefulWidget {
  const ToDos({Key? key}) : super(key: key);

  @override
  
  State<ToDos> createState() => _ToDosState();
}

class _ToDosState extends State<ToDos> {
  dynamic selectedTodo;
  int selectedTab = 0;
  dynamic toDoRef = FirebaseFirestore.instance.collection('todos').snapshots();
  void setSelectedTab(int index) {
    setState(() {
      selectedTab = index;
      switch (index) {
        case 0:
          toDoRef = FirebaseFirestore.instance.collection('todos').snapshots();
          break;
        case 1:
          toDoRef = FirebaseFirestore.instance.collection('todos').where('complited', isEqualTo: false).snapshots();
          break;
        case 2:
          toDoRef = FirebaseFirestore.instance.collection('todos').where('complited', isEqualTo: true).snapshots();
          break;
        default:
          toDoRef = FirebaseFirestore.instance.collection('todos').snapshots();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDos'),
      ),
      body: StreamBuilder(
        stream: toDoRef,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('no data'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final todo = snapshot.data!.docs[index];
              return Dismissible(
                  key: Key(todo['id']),
                  confirmDismiss: (DismissDirection direction) async {
                    switch (direction) {
                      case DismissDirection.endToStart:
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text("Are you sure you wish to delete this item?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("DELETE")
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                ),
                              ],
                            );
                          },
                        );
                      case DismissDirection.startToEnd:
                        return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text("Are you sure you wish to complete this item?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("COMPLETE")
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"),
                                  ),
                                ],
                              );
                            },
                          );
                      default:
                        break;
                    }
                  },
                  background: 
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                      color: Colors.green,
                      child: const Icon(Icons.check),
                    ),
                  secondaryBackground: 
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(Icons.delete_forever),
                    ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(todo['name'], 
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(todo['description'],
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                    ],),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    onTap: () {
                      selectedTodo = todo;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ToDo(selectedTodo: selectedTodo)),
                      );
                    },
                  ),
                );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: setSelectedTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox),
            label: 'All'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Active'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Complited',
          )
        ]),
    );
  }
  
}
