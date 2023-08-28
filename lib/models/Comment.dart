class Comment {
  String author = "";
  String text = "";
  String time = "";
  String toWhom = "";

  Comment(this.author, this.text, this.time, this.toWhom);

  static fromObject(Map comment) {
    return Comment(
        comment["author"], comment["text"], comment["time"], comment["toWhom"]);
  }
}
