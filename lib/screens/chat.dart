import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  String chatId;
  Chat({super.key, required this.chatId});

  @override
  State<Chat> createState() => _ChatState(chatId);
}

class _ChatState extends State<Chat> {
  String chatId;
  _ChatState(this.chatId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatId),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: 
          FirebaseFirestore.instance.collection('chats')
            .doc(chatId)
            .collection('messages')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (!snapshot.hasData) {
            return const Text('no data');
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final message = snapshot.data!.docs[index];
              return ListTile(
                title: Row(
                  children: [
                    Text(message['text'], 
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],),
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}