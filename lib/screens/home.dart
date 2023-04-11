import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutty/screens/account.dart';
import 'package:flutty/screens/login.dart';
import 'package:flutty/screens/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List menuList = [
    {
      'id': '0',
      'name': 'ToDos',
    },
    {
      'id': '1',
      'name': 'Chats',
    },
    {
      'id': '2',
      'name': 'Settings',
    },
  ];

  void redirect(screenName) {
    if (screenName == 'ToDos') {
      Navigator.pushNamedAndRemoveUntil(context, '/todos', (Route<dynamic> route) => true);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ToDos()),
      // );
    } else if (screenName == 'Chats') {
      Navigator.pushNamedAndRemoveUntil(context, '/chats', (Route<dynamic> route) => true);
    } else if (screenName == 'Settings') {
      Navigator.pushNamedAndRemoveUntil(context, '/settings', (Route<dynamic> route) => true);
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Flutty'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if ((user == null)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Account()),
                );
              }
            },
            icon: (user == null)
              ? const Icon(Icons.person_outlined)
              : const Icon(Icons.person)
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: (user == null)
            ? const Text('go login!')
            : ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final item = menuList[index];
                return TextButton(
                  onPressed: () {
                    redirect(item['name']);
                  },
                  child: Text(item['name'])
                );
              },
            ),
        ),
      ),
    );
  }
}