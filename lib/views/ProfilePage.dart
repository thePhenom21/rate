import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate/models/Comment.dart';
import 'package:rate/models/RateUser.dart';
import 'package:rate/providers/providers.dart';

class ProfilePage extends ConsumerWidget {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherusers = ref.watch(otherUsersProvider);
    final user = ref.watch(userProvider);
    return Scaffold(
      body: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          height: MediaQuery.of(context).size.height / 5,
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(user.email!),
                Row(
                  children: [
                    Icon(Icons.star),
                    Text(user.rating!.toStringAsFixed(1)),
                  ],
                )
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
