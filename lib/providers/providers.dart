import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rate/models/Comment.dart';
import 'package:rate/models/RateUser.dart';
import 'package:riverpod/riverpod.dart';

StateProvider userProvider = StateProvider<RateUser?>((ref) => null);
StateProvider colorProvider = StateProvider<bool>((ref) => true);
StateProvider messageProvider = StateProvider<String>((ref) => "");

StateProvider usrProvider = StateProvider<List<RateUser>>((ref) => []);
StateProvider otherUsersProvider = StateProvider<List>((ref) {
  List<Comment> otherusers = [];
  final usr = (ref.watch(userProvider) as RateUser);
  FirebaseFirestore.instance
      .collection("comments")
      .where("toWhom", isEqualTo: usr.email)
      .get()
      .then((value) => value.docs.forEach((element) {
            otherusers.add(Comment.fromObject(element.data()));
          }));
  return otherusers;
});
