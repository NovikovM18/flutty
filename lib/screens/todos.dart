import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutty/screens/todo.dart';
import 'package:flutty/utils/vars.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  showConfirmDialog(String type, String id) {
    switch (type) {
      case 'Complited':
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm'),
              content: const Text('Are you sure you wish to complete this item?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => updateToDo('Complited', id),
                  child: const Text('COMPLETE')
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('CANCEL'),
                ),
              ],
            );
          },
        );
      case 'Processed':
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm'),
              content: const Text('Are you sure you wish to process this item?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => updateToDo('Processed', id),
                  child: const Text('PROCESS')
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('CANCEL'),
                ),
              ],
            );
          },
        );
      default:
      break;
    }
  }

  updateToDo(String type, String id) {
    final ref = FirebaseFirestore.instance.collection('todos').doc(id);
    switch (type) {
      case 'Complited':
        ref.update({'complited': true}).then(
          (value) => {
            Navigator.of(context).pop(false)
          },
          onError: (e) => {
            showDialog(context: context, builder: (context) => 
              AlertDialog(
                title: Text(e.code),
              )
            ),
            Navigator.of(context).pop(false)
          }
        );
        break;
      case 'Processed':
        ref.update({'complited': false}).then(
          (value) => {
            Navigator.of(context).pop(false)
          },
          onError: (e) => {
            showDialog(context: context, builder: (context) => 
              AlertDialog(
                title: Text(e.code),
              )
            ),
            Navigator.of(context).pop(false)
          }
        );
        break;
      default:
    }
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
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final todo = snapshot.data!.docs[index];
              return Slidable(
                key: Key(todo['id']),
                endActionPane: ActionPane(
                  // dismissible: DismissiblePane(onDismissed: () => showConfirmDialog('Complited')), 
                  motion: const StretchMotion(), 
                  children: [
                    !todo['complited']
                    ? SlidableAction(
                        onPressed: (context) => showConfirmDialog('Complited', todo.id),
                        backgroundColor: Colors.green,
                        icon: Icons.access_alarm_sharp,
                        label: 'Complited',
                      )
                    : SlidableAction(
                        onPressed: (context) => showConfirmDialog('Processed', todo.id),
                        backgroundColor: Colors.yellow,
                        icon: Icons.access_alarm_sharp,
                        label: 'Processed',
                      )
                  ],
                ),
                child: ListTile(                  
                  title: Row(
                    children: [
                      if (selectedTab == 0) 
                      todo['complited'] 
                        ? const Icon(Icons.done_all, color: customColors.green,) 
                        : const Icon(Icons.work, color: customColors.yellow,),
                      const SizedBox(width: 20),
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
                    ],
                  ),
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
              // return Dismissible(
              //   key: Key(todo['id']),
              //   dismissThresholds: <DismissDirection, double>{},
              //   confirmDismiss: (DismissDirection direction) async {
              //     switch (direction) {
              //       case DismissDirection.startToEnd:
              //         return await showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return AlertDialog(
              //               title: const Text('Confirm'),
              //               content: const Text('Are you sure you wish to complete this item?'),
              //               actions: <Widget>[
              //                 TextButton(
              //                   onPressed: () => Navigator.of(context).pop(true),
              //                   child: const Text('COMPLETE')
              //                 ),
              //                 TextButton(
              //                   onPressed: () => Navigator.of(context).pop(false),
              //                   child: const Text('CANCEL'),
              //                 ),
              //               ],
              //             );
              //           },
              //         );
              //       case DismissDirection.endToStart:
              //         return await showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return AlertDialog(
              //               title: const Text('Confirm'),
              //               content: const Text('Are you sure you wish to delete this item?'),
              //               actions: <Widget>[
              //                 TextButton(
              //                   onPressed: () => Navigator.of(context).pop(true),
              //                   child: const Text('DELETE')
              //                 ),
              //                 TextButton(
              //                   onPressed: () => Navigator.of(context).pop(false),
              //                   child: const Text('CANCEL'),
              //                 ),
              //               ],
              //             );
              //           },
              //         );
              //       default:
              //         break;
              //     }
              //   },
              //   background: 
              //     Container(
              //       padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              //       alignment: Alignment.centerLeft,
              //       color: Colors.green,
              //       child: const Icon(Icons.check, color: Colors.white),
              //     ),
              //   secondaryBackground: 
              //     Container(
              //       padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              //       alignment: Alignment.centerRight,
              //       color: Colors.red,
              //       child: const Icon(Icons.delete_forever, color: Colors.white),
              //     ),
              //   child: ListTile(                  
              //     title: Row(
              //       children: [
              //         if (selectedTab == 0) 
              //         todo['complited'] 
              //           ? const Icon(Icons.done_all, color: customColors.green,) 
              //           : const Icon(Icons.work, color: customColors.yellow,),
              //         const SizedBox(width: 20),
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(todo['name'], 
              //                 style: Theme.of(context).textTheme.bodyMedium,
              //                 maxLines: 1,
              //                 overflow: TextOverflow.ellipsis,
              //               ),
              //               Text(todo['description'],
              //                 style: Theme.of(context).textTheme.bodySmall,
              //                 maxLines: 2,
              //                 overflow: TextOverflow.ellipsis,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //     trailing: const Icon(Icons.arrow_forward_ios),
              //     contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              //     onTap: () {
              //       selectedTodo = todo;
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => ToDo(selectedTodo: selectedTodo)),
              //       );
              //     },
              //   ),
              // );
            }, 
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 4);
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
