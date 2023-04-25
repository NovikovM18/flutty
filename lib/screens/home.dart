import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutty/screens/account.dart';
import 'package:flutty/screens/login.dart';
import 'package:flutty/utils/vars.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List menuList = [
    {
      'id': '0',
      'name': 'Chats',
      'icon': Icons.chat
    },
    {
      'id': '1',
      'name': 'ToDos',
      'icon': Icons.today
    },
    {
      'id': '2',
      'name': 'Calendar',
      'icon': Icons.calendar_month
    },
  ];

  void redirect(screenName) {
    switch (screenName) {
      case 'Chats':
        Navigator.pushNamedAndRemoveUntil(context, '/chats', (Route<dynamic> route) => true);
        break;
      case 'ToDos':
        Navigator.pushNamedAndRemoveUntil(context, '/todos', (Route<dynamic> route) => true);
        break;
      case 'Calendar':
        Navigator.pushNamedAndRemoveUntil(context, '/calendar', (Route<dynamic> route) => true);
        break;
      default:
    }
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(images.imageBG),
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('C R S',
                    style: Theme.of(context).textTheme.bodyLarge!
                      .copyWith(fontSize: 88),
                      textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text('NIGGERS WORK HARD',
                    style: Theme.of(context).textTheme.bodyMedium!
                      .copyWith(fontSize: 66),
                      textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
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
              ],
            ),
          ),
        ),
      ]
    );
  }
}