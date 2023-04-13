import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutty/screens/account.dart';
import 'package:flutty/screens/login.dart';

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
      'icon': Icons.today
    },
    {
      'id': '1',
      'name': 'Chats',
      'icon': Icons.chat
    },
  ];

  void redirect(screenName) {
    if (screenName == 'ToDos') {
      Navigator.pushNamedAndRemoveUntil(context, '/todos', (Route<dynamic> route) => true);
    } else if (screenName == 'Chats') {
      Navigator.pushNamedAndRemoveUntil(context, '/chats', (Route<dynamic> route) => true);
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://i.pinimg.com/474x/04/c2/3d/04c23d5d2d6c90fbaab2c1c0704d1102.jpg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Flutty'),
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
          body: Container(
            child: (user == null)
              ? const Center(child: Text('go login!'))
              : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2
                ),
                itemCount: menuList.length,
                itemBuilder: (context, index) {
                  final item = menuList[index];
                  return Card(
                    child: InkResponse(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], size: 58),
                          Text(item['name'], style: Theme.of(context).textTheme.bodyLarge),
                          Text('${item['name']} screen',style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      onTap: () => redirect(item['name']),
                    ),
                  );
                }, 
              ),
          ),
        ),
      ]
    );
  }
}