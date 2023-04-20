import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutty/screens/chat.dart';
import 'package:flutty/utils/vars.dart';
import 'package:multiselect/multiselect.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final user = FirebaseAuth.instance.currentUser;
  PageController pageController = PageController(initialPage: 0, keepPage: false);
  List<dynamic> allUsers = [
    {'id': '888sdsdg', 'name': 'Looo'},
    {'id': '888dsdsdsddsg', 'name': 'Looo'},
    {'id': '888fdsg', 'name': 'Looo'},
    {'id': '888dfwwwg', 'name': 'Looo'},
    {'id': '888ffdfdg', 'name': 'Looo'},
    {'id': '888afaasg', 'name': 'Looo'},
    {'id': '88ffffdfd8g', 'name': 'Looo'},
    {'id': '888lkjg', 'name': 'Looo'},
    {'id': '88jklh8g', 'name': 'Looo'},
    {'id': '88hhkl8g', 'name': 'Looo'},
    {'id': '877tgj88g', 'name': 'Looo'},
    {'id': '87755f88g', 'name': 'Looo'},
    {'id': '889uh8g', 'name': 'Looo'},
    {'id': '88jg58g', 'name': 'Looo'},
    {'id': '888yg8g', 'name': 'Looo'},
    {'id': '888ghj8g', 'name': 'Looo'},
    {'id': '88097hb8g', 'name': 'Looo'},
    {'id': '8800ou8g', 'name': 'Looo'},
    {'id': '88ggg668g', 'name': 'Looo'},
    {'id': '888gsdsd', 'name': 'Looo'},
    {'id': '888sd', 'name': 'Looo'},
  ];
  List<dynamic> selectedUsers = [];
  TextEditingController nameTextInputController = TextEditingController();
  TextEditingController descriptionTextInputController = TextEditingController();
  int currentPage = 0;
  swapPage() {
    if (pageController.page == 0) {
      pageController.animateToPage(1, duration: const Duration(milliseconds: 99), curve: Curves.linear);
      setState(() {
        currentPage = 1;
      });
    } 
    if (pageController.page == 1) {
      pageController.animateToPage(0, duration: const Duration(milliseconds: 99), curve: Curves.linear);
      setState(() {
        currentPage = 0;
      });
    } 
  }
  
  addUserToList(String id) {
    if (selectedUsers.contains(id)) {
      setState(() {
        selectedUsers.remove(id);
      });
    } else {
      setState(() {
        selectedUsers.add(id);
      });
    }
  }

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
          content: Column(
              children: [
                // Flexible(
                //   child:
                //   Column(
                //     children: [

                //       TextFormField(
                //         keyboardType: TextInputType.text,
                //         autocorrect: false,
                //         controller: nameTextInputController,
                //         decoration: const InputDecoration(
                //           labelText: 'Name',
                //           border: OutlineInputBorder(),
                //         ),
                //       ),

                //       TextFormField(
                //         keyboardType: TextInputType.text,
                //         autocorrect: false,
                //         controller: descriptionTextInputController,
                //         decoration: const InputDecoration(
                //           labelText: 'Description',
                //           border: OutlineInputBorder(),
                //         ),
                //       ),
                //     ],
                //   )
                // ),

                //  DropDownMultiSelect(
                //   options: allUsers.map((e) => e['name']).toList(),
                //   selectedValues: selectedUsers.map((e) => e['name']).toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       selectedUsers = value;
                //     });
                //     print('you have selected $selectedUsers fruits.');
                //   },
                // ),

                Flexible(
                  child: StreamBuilder(
                    stream: 
                      FirebaseFirestore.instance.collection('users')
                      .orderBy('name')
                      .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Text('no users');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        // physics: BouncingScrollPhysics(),
                        // controller: scrollController,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final user = snapshot.data!.docs[index];
                          return ListTile(
                            tileColor: const Color.fromARGB(0, 0, 0, 0),
                            title: Text(user['name']),
                            contentPadding: const EdgeInsets.all(4),
                            onTap: () {},
                          );
                        },
                      );
                    },
                  ),
                )
              ],
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
    selectedUsers.add(user!.uid);
    var chat = {
      'id': DateTime.now().millisecondsSinceEpoch.toString() + user!.uid.toString(),
      'name': nameTextInputController.text,
      'description': descriptionTextInputController.text,
      'created_at': FieldValue.serverTimestamp(),
      'users': selectedUsers
    };
    final ref = FirebaseFirestore.instance.collection('chats');
    await ref.doc(DateTime.now().millisecondsSinceEpoch.toString() + user!.uid.toString()).set(chat);
    nameTextInputController.clear();
    descriptionTextInputController.clear();
    setState(() {
      selectedUsers = [];
    });
    pageController.animateToPage(0, duration: Duration(milliseconds: 99), curve: Curves.linear);
  }
  
  Future deleteChat() async {

  }

  bool loading = true;

  getChats() {
    setState(() {
      loading = true;
    });
    FirebaseFirestore.instance.collection('users').where('id', isNotEqualTo: user!.uid).get()
      .then((querySnapshot) {
        print('*************************');
          for (var docSnapshot in querySnapshot.docs) {
            print('${docSnapshot.id} => ${docSnapshot.data()}');
            setState(() {
              allUsers.add(docSnapshot.data());
            });
          }
        print(allUsers);
        loading = false;
      },
      onError: (e) => {
        setState(() {
          loading = false;
        })
      },
    );
  }

  @override
    void initState() {
    super.initState();
    getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
      ),
      body: PageView(
        controller: pageController,
        children:[ 
          StreamBuilder(
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
                    startActionPane: ActionPane(
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

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  children: [
                    Text('Add chat', style: Theme.of(context).textTheme.bodyLarge),
                    
                    const SizedBox(height: 24),
                    
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
              
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              Flexible(
                child: loading 
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: ListView.separated(
                      // shrinkWrap: true,
                      // physics: BouncingScrollPhysics(),
                      // controller: scrollController,
                      itemCount: allUsers.length,
                      itemBuilder: (context, index) {
                        final user = allUsers[index];
                        return selectedUsers.contains(user['id'])
                        ? ListTile(
                            tileColor: customColors.green,
                            title: Text(user['name'], style: TextStyle(color: Colors.black),),
                            contentPadding: const EdgeInsets.all(4),
                            onTap: () => addUserToList(user['id']),
                          )
                        : ListTile(
                            tileColor: const Color.fromARGB(0, 0, 0, 0),
                            title: Text(user['name']),
                            contentPadding: const EdgeInsets.all(4),
                            onTap: () => addUserToList(user['id']),
                          );
                      }, 
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 4);
                      },
                    ),
                )
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                child: ElevatedButton(
                  style: 
                    ElevatedButton.styleFrom(
                      primary: customColors.green,
                      fixedSize: const Size(200, 60)
                    ),
                  onPressed: addChat, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [                      
                      Text('add chat', style: TextStyle(color: Colors.black, fontSize: 22))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: swapPage,
        child: currentPage == 0 
          ? const Icon(Icons.add_comment) 
          : const Icon(Icons.arrow_back_ios_new),
      ),
    );
  }
}