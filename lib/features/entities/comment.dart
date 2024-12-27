import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timeStamp;

  Comment(
      {required this.userId,
      required this.id,
      required this.postId,
      required this.text,
      required this.userName,
      required this.timeStamp});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'postId': postId,
      'text': text,
      'userName': userName,
      'timeStamp': Timestamp.fromDate(timeStamp),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['userId'],
      id: json['id'],
      postId: json['postId'],
      text: json['text'],
      userName: json['userName'],
      timeStamp: (json['timeStamp'] as Timestamp).toDate(),
    );
  }
}
