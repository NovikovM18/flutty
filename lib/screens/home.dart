import 'package:flutter/material.dart';
import 'package:flutty/screens/menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutty'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Menu()),
              );
            },
            icon: const Icon(Icons.menu_outlined),
          ),
        ],
      ),

      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: Text(
              'Hi nigga!',
              style: TextStyle(
                fontSize: 32,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}