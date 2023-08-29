import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate/models/RateUser.dart';
import 'package:rate/providers/user_provider.dart';

StateProvider usrProvider = StateProvider<List<RateUser>>((ref) => []);

class SearchPage extends ConsumerWidget {
  TextEditingController searchController = TextEditingController();
  String email = "";

  SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usr = ref.watch(usrProvider);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (value) async {
                List<RateUser> l =
                    await searchUser(searchController.value.text, ref)
                        .then((value) => value);
                ref.read(usrProvider.notifier).update((state) => l);
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
                                addComment(usr[index].email!, ref);
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

  Future<List<RateUser>> searchUser(String searchText, WidgetRef ref) async {
    List<RateUser> liste = [];
    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isGreaterThanOrEqualTo: searchText)
        .where("email", isLessThanOrEqualTo: searchText + "\uf8ff")
        .where("email",
            isNotEqualTo: (ref.read(userProvider) as RateUser).email)
        .get()
        .then((value) => value.docs.forEach((element) {
              liste.add(RateUser.fromUser(element.data()));
            }));
    return liste;
  }

  addComment(String email, WidgetRef ref) async {
    TextEditingController a = TextEditingController();

    showDialog(
        context: DisposableBuildContext as BuildContext,
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
                    "author": ref.read(userProvider)
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
