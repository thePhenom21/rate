import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rate/models/Comment.dart';
import 'package:rate/models/RateUser.dart';

class ProfilePage extends StatefulWidget {
  RateUser user;
  ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Comment> otherusers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      otherusers = [];

      FirebaseFirestore.instance
          .collection("comments")
          .where("toWhom", isEqualTo: widget.user.email)
          .get()
          .then((value) => value.docs.forEach((element) {
                setState(() {
                  otherusers.add(Comment.fromObject(element.data()));
                });
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          height: MediaQuery.of(context).size.height / 5,
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.user.email!),
                Text(widget.user.rating!.toStringAsFixed(1))
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).orientation != Orientation.landscape
              ? 2 * MediaQuery.of(context).size.height / 5
              : 1 * MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.width - 10,
          child: ListView.builder(
            itemCount: otherusers.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.height / 5,
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Text(otherusers[index].text, maxLines: 2)),
                      Expanded(
                        child: Text(
                          otherusers[index].author,
                          maxLines: 2,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          otherusers[index].time,
                          overflow: TextOverflow.fade,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ]),
    );
  }

  getUser(String email) {}
}
