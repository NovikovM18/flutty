import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final user = FirebaseAuth.instance.currentUser;
  var monthName = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };
  String formaTime(time) => time > 9 ? time.toString() : '0' + time.toString();
  final textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  void scrollToTheEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent, 
      duration: const Duration(milliseconds: 222), 
      curve: Curves.ease
    );
  }
  Future<void> sendMessage() async {
    var message = {
      'sender': user!.uid,
      'text': textController.text,
      'time': DateTime.now()
    };
    final ref = FirebaseFirestore.instance
    .collection('chats/$chatId/messages/');
    await ref.doc(DateTime.now().millisecondsSinceEpoch.toString() + user!.uid.toString()).set(message);
    textController.text = '';
    scrollToTheEnd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: 
                FirebaseFirestore.instance.collection('chats/$chatId/messages')
                .orderBy('time')
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Text('no messages');
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data!.docs[index];
                    Timestamp time = message['time'] as Timestamp;
                    DateTime date = time.toDate();
                    return ListTile(
                      title: (user!.uid != message['sender']) 
                      ? Row(
                          mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                                margin: const EdgeInsets.only(right: 18),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(message['text'], 
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Padding(padding:EdgeInsets.only(top: 2)),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${date.day} ${monthName[date.month]} ${date.year}',
                                          style: const TextStyle(
                                            fontSize: 12
                                          ),  
                                        ),
                                        const Padding(padding:EdgeInsets.only(left: 8)),
                                        Text('${formaTime(date.hour)}:${formaTime(date.minute)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment:MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                                margin: const EdgeInsets.only(left: 18),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  border: Border.all(color: Colors.green),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(4),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(message['text'], 
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Padding(padding:EdgeInsets.only(top: 2)),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${date.day} ${monthName[date.month]} ${date.year}',
                                          style: const TextStyle(
                                            fontSize: 12
                                          ),  
                                        ),
                                        const Padding(padding:EdgeInsets.only(left: 8)),
                                        Text('${formaTime(date.hour)}:${formaTime(date.minute)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      contentPadding: const EdgeInsets.all(4),
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  color: Colors.deepPurple[50],
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onTap: () {
                            Timer(const Duration(milliseconds: 666), () => scrollToTheEnd());
                          },
                          decoration: const InputDecoration(
                            hintText: 'Type Something...',
                            hintStyle: TextStyle(color: Colors.black38),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0)
                          ),
                        )
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (textController.text.isNotEmpty) sendMessage();
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
              )
            ],
          )
        ],
      ),
    );
  }
}