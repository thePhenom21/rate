import 'dart:ffi';

class RateUser {
  String? email;
  double? rating;
  int? commentCount;

  RateUser(this.email, this.rating, this.commentCount);

  static fromUser(Map user) {
    return RateUser(user["email"], (user["rating"] as int).toDouble(),
        user["commentCount"] as int);
  }
}
