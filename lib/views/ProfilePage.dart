import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  String user;
  ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        Card(
          child: Row(
            children: [Text(widget.user)],
          ),
        )
      ]),
    );
  }

  getUser(String email) {}
}
