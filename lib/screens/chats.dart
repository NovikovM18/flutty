import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutty/screens/chat.dart';
import 'package:flutty/utils/vars.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final user = FirebaseAuth.instance.currentUser;
  dynamic allUsers;
  TextEditingController nameTextInputController = TextEditingController();
  TextEditingController descriptionTextInputController = TextEditingController();

  addNewChat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('New chat'),
            ],
          ),
          content: Container(
            height: 300,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  controller: nameTextInputController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  controller: descriptionTextInputController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),

                // DropdownButtonFormField(
                //   items: <String>['Dog', 'Cat', 'Tiger', 'Lion']
                //     .map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(
                //           value,
                //           style: TextStyle(fontSize: 20),
                //         ),
                //       );
                //     }).toList(), 
                //   onChanged: (value) => {
                //     print(value)
                //   },
                  
                // ),

                
            
              ],
            )
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => {
                nameTextInputController.clear(),
                descriptionTextInputController.clear(),
                Navigator.of(context).pop(false),
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => {
                addChat(),
                Navigator.of(context).pop(true)
              },
              child: const Text('ADD')
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceAround
        );
      },
    );
  }

  confirmDeleteChat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure to delete this chat?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('DELETE')
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }
  
 Future<void> addChat() async {
    var chat = {
      'id': DateTime.now().millisecondsSinceEpoch.toString() + user!.uid.toString(),
      'name': nameTextInputController.text,
      'description': descriptionTextInputController.text,
      'created_at': FieldValue.serverTimestamp(),
      'users': [user!.uid]
    };
    final ref = FirebaseFirestore.instance.collection('chats');
    await ref.doc(DateTime.now().millisecondsSinceEpoch.toString() + user!.uid.toString()).set(chat);
    nameTextInputController.clear();
    descriptionTextInputController.clear();
  }
  
  Future deleteChat() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats')
          .where('users', arrayContains: user!.uid)
          // .orderBy('created_at', descending: true)
          .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
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
              final chat = snapshot.data!.docs[index];
              return Slidable(
                key: Key(chat['id']),
                endActionPane: ActionPane(
                  extentRatio: 0.25,
                  // dismissible: DismissiblePane(onDismissed: () => showDialogs('Complited')), 
                  motion: const StretchMotion(), 
                  children: [
                    SlidableAction(
                      onPressed: (context) => confirmDeleteChat(),
                      backgroundColor: Colors.red,
                      icon: Icons.delete_forever,
                      label: 'Delete',
                    )
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(),
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(chat['name'], 
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                  ],),
                  subtitle: Row(
                    children: [
                      Text(chat['description'], 
                        style:Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Chat(chatId: chat.id,)),
                    );
                  },
                  onLongPress: () {},
                ),
              );
            }, 
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 4);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewChat,
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}