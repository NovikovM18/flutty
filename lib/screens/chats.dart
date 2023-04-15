import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutty/screens/chat.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final user = FirebaseAuth.instance.currentUser;
  addNewChat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New chat'),
          content: Container(
            height: 100,
            child: Column(
              children: [
                Text('Set form'),
                Text('Set form'),
                Text('Set form'),
                Text('Set form'),
              ],
            )
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
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
  
  Future addChat() async {

  }
  
  Future deleteChat() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat list'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats')
          .where('users', arrayContains: user!.uid)
          .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Text('no data');
          }
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final chat = snapshot.data!.docs[index];
              return Slidable(
                key: Key(chat['id']),
                endActionPane: ActionPane(
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