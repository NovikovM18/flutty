import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutty/utils/vars.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(context: context, builder: (context) => 
        AlertDialog(
          title: Text(e.code),
        )
      );
      if (e.code.isNotEmpty) {
        showDialog(context: context, builder: (context) => 
          AlertDialog(
            title: Text(e.code),
          )
        );
        return;
      } else {
        showDialog(context: context, builder: (context) => 
          AlertDialog(
            title: Text(e.code),
          )
        );
        return;
      }
    }
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

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
            title: const Text('Signin'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    controller: emailTextInputController,
                    validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                        ? 'Email is invalid'
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    autocorrect: false,
                    controller: passwordTextInputController,
                    obscureText: isHiddenPassword,
                    validator: (value) => value != null && value.length < 6
                        ? 'Minimum password length is 6 characters'
                        : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffix: InkWell(
                        onTap: togglePasswordView,
                        child: Icon(
                          isHiddenPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: login,
                    child: const Center(child: Text('Signin')),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/signup'),
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/reset_password'),
                    child: const Text('Reset password'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}