import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rate/models/RateUser.dart';
import 'package:rate/views/HomePage.dart';

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
  User? user;
  RateUser? loggedUser;

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
                          loggedUser = await FirebaseFirestore.instance
                              .collection("users")
                              .where("email", isEqualTo: user!.email)
                              .get()
                              .then((value) =>
                                  RateUser.fromUser(value.docs[0].data()));
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return HomePage(user: loggedUser!);
                            },
                          ));
                        } catch (err) {
                          print(err);
                        }
                      },
                      child: const Text("Login")),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          user = await register(emailController.value.text,
                              passwordController.value.text);
                        } on FirebaseAuthException catch (err) {
                          print(err.message);
                        }
                      },
                      child: const Text("Register"))
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
            ),
            ElevatedButton(
                onPressed: () {
                  resetPassword(emailController.value.text);
                },
                child: const Text("Reset Password"))
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
        message = "${user.user!.email} logged in successfully!";
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
      await FirebaseFirestore.instance
          .collection("users")
          .add({"email": email, "commentCount": 0, "rating": 0});
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

  resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        color = true;
        message = "Check your email for the password reset link!";
      });
    } catch (err) {
      setState(() {
        color = false;
        message = "There is an error with the password reset service";
      });
    }
  }
}
