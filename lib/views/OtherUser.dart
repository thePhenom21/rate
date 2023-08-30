import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate/models/RateUser.dart';
import 'package:rate/providers/providers.dart';

import '../models/Comment.dart';

StateProvider<List<Comment>> comments_other = StateProvider((ref) {
  List<Comment> otherusers = [];
  FirebaseFirestore.instance
      .collection("comments")
      .where("toWhom", isEqualTo: ref.watch(otherUserProvider)!.email)
      .get()
      .then((value) => value.docs.forEach((element) {
            otherusers.add(Comment.fromObject(element.data()));
          }));
  return otherusers;
});

class OtherUser extends ConsumerWidget {
  const OtherUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherUser = ref.watch(otherUserProvider);
    final comments = ref.watch(comments_other);
    return Scaffold(
      body: Center(
        child: Column(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height / 5,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(otherUser!.email!),
                  Row(
                    children: [
                      Icon(Icons.star),
                      Text(otherUser.rating!.toStringAsFixed(1)),
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
              itemCount: comments.length,
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
                            child: Text(comments[index].text, maxLines: 2)),
                        Expanded(
                          child: Text(
                            comments[index].author,
                            maxLines: 2,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            comments[index].time,
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
      ),
    );
  }
}
