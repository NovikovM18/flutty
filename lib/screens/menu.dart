import 'package:flutter/material.dart';
import 'package:flutty/screens/chats.dart';
import 'package:flutty/screens/settings.dart';
import 'package:flutty/screens/todos.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  List menuList = [];

  void menuRedirect(screenName) {
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

  void initState() {
    super.initState();
    menuList.addAll([
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: menuList.length,
        itemBuilder: (context, index) {
          final item = menuList[index];
          return TextButton(
            onPressed: () {
              menuRedirect(item['name']);
            },
            child: Text(item['name'])
          );
        },
      ),
    );
  }
}
