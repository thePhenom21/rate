import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String message = "";
  bool color = true;
  User? user = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          user = await login(emailController.value.text,
                              passwordController.value.text);
                          emailController.clear();
                          passwordController.clear();
                        } catch (err) {
                          print("login error");
                        }
                      },
                      child: Text("Login")),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          user = await register(emailController.value.text,
                              passwordController.value.text);
                        } on FirebaseAuthException catch (err) {
                          print(err.message);
                        }
                      },
                      child: Text("Register"))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                textAlign: TextAlign.center,
                message,
                style:
                    TextStyle(color: color == true ? Colors.green : Colors.red),
              ),
            )
          ],
        ),
      )),
    );
  }

  login(String email, String password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        color = true;
        message = "Login successful!";
      });
      return user.user;
    } on FirebaseAuthException catch (err) {
      setState(() {
        color = false;
        message = err.message!;
      });
    }
  }

  register(String email, String password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      setState(() {
        color = true;
        message = "User with email ${user.user!.email} created successfully";
      });
      return user;
    } on FirebaseAuthException catch (err) {
      setState(() {
        emailController.clear();
        passwordController.clear();
        color = false;
        message = err.message!;
      });
    }
  }
}
