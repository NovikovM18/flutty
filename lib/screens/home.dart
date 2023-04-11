import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutty/screens/account.dart';
import 'package:flutty/screens/chats.dart';
import 'package:flutty/screens/login.dart';
import 'package:flutty/screens/menu.dart';
import 'package:flutty/screens/settings.dart';
import 'package:flutty/screens/todos.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List menuList = [
    {
      'id': '0',
      'name': 'ToDo',
    },
    {
      'id': '1',
      'name': 'Chat',
    },
    {
      'id': '2',
      'name': 'Settings',
    },
  ];

  void redirect(screenName) {
    Navigator.pop(context);
    if (screenName == 'ToDo') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ToDos()),
      );
    } else if (screenName == 'Chat') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Chats()),
      );
    } else if (screenName == 'Settings') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Settings()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Главная страница'),
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
            icon: Icon(
              Icons.person,
              color: (user == null) ? Colors.white : Colors.yellow,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: (user == null)
            ? const Text("Контент для НЕ зарегистрированных в системе")
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