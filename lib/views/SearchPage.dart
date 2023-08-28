import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rate/models/RateUser.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  RateUser usr = RateUser("", 0, 0);
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onSubmitted: (value) async {
                usr = await searchUser(searchController.value.text);
                setState(() {
                  email = usr.email!;
                });
              },
            ),
          ),
          Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(email),
                  ElevatedButton(
                      onPressed: () {
                        addComment(email);
                      },
                      child: Icon(Icons.add))
                ]),
          )
        ],
      ),
    );
  }

  searchUser(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: searchController.value.text)
        .get()
        .then((value) => RateUser.fromUser(value.docs[0].data()));
  }

  addComment(String email) async {
    TextEditingController a = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(actions: [
            TextField(
              controller: a,
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection("comments").add({
                    "text": a.value.text,
                    "time": "a",
                    "toWhom": email,
                    "author": "aaaaasdsadsa"
                  });
                },
                child: Icon(Icons.send)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.delete))
          ]);
        });
  }
}
