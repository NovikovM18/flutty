import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutty/screens/account.dart';
import 'package:flutty/screens/chats.dart';
import 'package:flutty/screens/home.dart';
import 'package:flutty/screens/login.dart';
import 'package:flutty/screens/reset_pass.dart';
import 'package:flutty/screens/signup.dart';
import 'package:flutty/screens/todos.dart';
import 'package:flutty/screens/verify_email.dart';
import 'package:flutty/services/firebase_auth_stream.dart';
import 'package:flutty/utils/theme.dart';
import 'utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: darkTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const FirebaseAuthStream(),
        '/home': (context) => const Home(),
        '/account': (context) => const Account(),
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/reset_password': (context) => const ResetPass(),
        '/verify_email': (context) => const VerifyEmail(),
        '/todos': (context) => const ToDos(),
        '/chats': (context) => const Chats(),
      },
    );
  }
}
