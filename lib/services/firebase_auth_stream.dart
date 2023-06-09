import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutty/screens/home.dart';
import 'package:flutty/screens/verify_email.dart';

class FirebaseAuthStream extends StatelessWidget {
  const FirebaseAuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
              body: Center(
                child: Text('Auth error!!!')
              )
            );
        } else if (snapshot.hasData) {
          if (!snapshot.data!.emailVerified) {
            return const VerifyEmail();
          }
          return const Home();
        } else {
          return const Home();
        }
      },
    );
  }
}