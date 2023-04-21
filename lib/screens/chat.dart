import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../utils/vars.dart';

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

  dynamic selectedChat;
  bool loading = false;
  getChat() {
    setState(() {
      loading = true;
    });
    FirebaseFirestore.instance.collection('chats').doc(chatId).get()
      .then(
        (DocumentSnapshot doc) {
          setState(() {
            selectedChat = doc.data() as Map<String, dynamic>;
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

  String formaTime(time) => time > 9 ? time.toString() : '0' + time.toString();
  final textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  void scrollToTheEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent, 
      duration: const Duration(milliseconds: 224), 
      curve: Curves.ease
    );
  }
  int messagesCount = 12;
  Future<void> sendMessage() async {
    var message = {
      'sender': user!.uid,
      'text': textController.text,
      'time': DateTime.now(),
    };
    final ref = FirebaseFirestore.instance.collection('chats/$chatId/messages/');
    await ref.doc(DateTime.now().millisecondsSinceEpoch.toString() + user!.uid.toString()).set(message);
    textController.text = '';
    Timer(const Duration(milliseconds: 500), () => scrollToTheEnd());
  }

  showChatInfo() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog (
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Chat info')
            ]
          ),
          content: loading 
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  children: [
                  Text('Name: ', style: Theme.of(context).textTheme.bodyMedium),
                  Text(selectedChat['name']),
                  ],
                ),
                const SizedBox(height: 12),
                
                Wrap(
                  children: [
                  Text('Created at: ', style: Theme.of(context).textTheme.bodyMedium),
                  Text(selectedChat['created_at'].toString()),
                  ],
                ),
                const SizedBox(height: 12),
                
                Text('Members:', style: Theme.of(context).textTheme.bodyMedium),
                SizedBox (
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                      // shrinkWrap: true,
                    // physics: BouncingScrollPhysics(),
                    // controller: scrollController,
                    itemCount: selectedChat['users'].length,
                    itemBuilder: (context, index) {
                      final user = selectedChat['users'][index];
                      return ListTile(
                          tileColor: const Color.fromARGB(0, 0, 0, 0),
                          leading: CircleAvatar(),
                          title: Text(user),
                          contentPadding: const EdgeInsets.all(0),
                        );
                    },
                  )
                ),
              ],
            ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getChat();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: showChatInfo, 
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: 
                FirebaseFirestore.instance.collection('chats/$chatId/messages')
                .orderBy('time')
                .limitToLast(messagesCount)
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
                SchedulerBinding.instance.addPostFrameCallback((context) {
                  scrollToTheEnd();
                });
                return ListView.builder(
                  shrinkWrap: true,
                  // physics: BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data!.docs[index];
                    Timestamp time = message['time'] as Timestamp;
                    DateTime date = time.toDate();
                    return ListTile(
                      tileColor: const Color.fromARGB(0, 0, 0, 0),
                      title: (user!.uid != message['sender']) 
                      ? Row(
                          mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                                margin: const EdgeInsets.only(right: 18),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(2),
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
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
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(2),
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
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
        ],
      ),
    );
  }
}