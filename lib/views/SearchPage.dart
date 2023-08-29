import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rate/models/RateUser.dart';

class SearchPage extends StatefulWidget {
  RateUser thisUser;
  SearchPage({super.key, required this.thisUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<RateUser> usr = [];
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
              onChanged: (value) async {
                usr = await searchUser(searchController.value.text)
                    .then((value) => value);
                setState(() {
                  usr;
                });
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: ListView.builder(
                itemCount: usr.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(usr[index].email!),
                          ElevatedButton(
                              onPressed: () {
                                addComment(usr[index].email!);
                              },
                              child: Icon(Icons.comment)),
                          ElevatedButton(
                              onPressed: () {
                                addRating(usr[index].email!);
                              },
                              child: Icon(Icons.star_rate))
                        ]),
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<List<RateUser>> searchUser(String searchText) async {
    List<RateUser> liste = [];
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isGreaterThanOrEqualTo: searchText)
        .where("email", isLessThanOrEqualTo: searchText + "\uf8ff")
        .where("email", isNotEqualTo: widget.thisUser.email)
        .get()
        .then((value) => value.docs.forEach((element) {
              liste.add(RateUser.fromUser(element.data()));
            }));
    return liste;
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
                    "time": DateTime.now().toString(),
                    "toWhom": email,
                    "author": widget.thisUser.email
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

  addRating(String email) async {
    QueryDocumentSnapshot val = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((value) => value.docs[0]);
    Map data = val.data() as Map;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(val.id)
        .update({"rating": data["rating"] + 1});
  }
}
