import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate/models/RateUser.dart';
import 'package:rate/providers/providers.dart';
import 'package:rate/views/HomePage.dart';
import 'package:flutter/services.dart';

class LoginPage extends ConsumerWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  User? user;
  RateUser? loggedUser;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(messageProvider);
    final color = ref.watch(colorProvider);
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
                obscureText: true,
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
                              passwordController.value.text, ref);
                          emailController.clear();
                          passwordController.clear();
                          loggedUser = await FirebaseFirestore.instance
                              .collection("users")
                              .where("email", isEqualTo: user!.email)
                              .get()
                              .then((value) =>
                                  RateUser.fromUser(value.docs[0].data()));
                          ref
                              .read(userProvider.notifier)
                              .update((state) => loggedUser);
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((event) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return ref.watch(homePageProvider) as HomePage;
                            }));
                          });
                        } catch (err) {
                          print(err);
                        }
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        ref
                            .read(messageProvider.notifier)
                            .update((state) => "");
                      },
                      child: const Text("Login")),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          user = await register(emailController.value.text,
                              passwordController.value.text, ref);
                        } on FirebaseAuthException catch (err) {
                          print(err.message);
                        }
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        ref
                            .read(messageProvider.notifier)
                            .update((state) => "");
                      },
                      child: const Text("Register"))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: color == true ? Colors.green : Colors.red),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  resetPassword(emailController.value.text, ref);
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                },
                child: const Text("Reset Password"))
          ],
        ),
      )),
    );
  }

  login(String email, String password, WidgetRef ref) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      ref.read(colorProvider.notifier).update((state) => true);
      ref
          .read(messageProvider.notifier)
          .update((state) => "${user.user!.email} logged in successfully!");

      return user.user;
    } on FirebaseAuthException catch (err) {
      ref.read(colorProvider.notifier).update((state) => false);
      ref.read(messageProvider.notifier).update((state) => err.message!);
    }
  }

  register(String email, String password, WidgetRef ref) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection("users")
          .add({"email": email, "commentCount": 0, "rating": 0});

      ref.read(colorProvider.notifier).update((state) => true);
      ref.read(messageProvider.notifier).update((state) =>
          "User with email ${user.user!.email} created successfully");

      return user;
    } on FirebaseAuthException catch (err) {
      emailController.clear();
      passwordController.clear();

      ref.read(colorProvider.notifier).update((state) => false);
      ref.read(messageProvider.notifier).update((state) => err.message!);
    }
  }

  resetPassword(String email, WidgetRef ref) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ref.read(colorProvider.notifier).update((state) => true);
      ref
          .read(messageProvider.notifier)
          .update((state) => "Check your email for the password reset link!");
    } catch (err) {
      ref.read(colorProvider.notifier).update((state) => false);
      ref.read(messageProvider.notifier).update(
          (state) => "There is an error with the password reset service");
    }
  }
}
