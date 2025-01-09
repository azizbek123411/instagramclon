import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timStamp;
  final List<String> likes;
  final List<Comment> comments;

  Post(
      {required this.text,
      required this.userId,
      required this.id,
      required this.timStamp,
      required this.imageUrl,
      required this.userName,
      required this.likes,
      required this.comments});

  Post copyWith({String? imageUrl}) {
    return Post(
        text: text,
        userId: userId,
        id: id,
        timStamp: timStamp,
        imageUrl: imageUrl ?? this.imageUrl,
        userName: userName,
        likes: likes,
        comments: comments);
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'userId': userId,
      'id': id,
      'timStamp': Timestamp.fromDate(timStamp),
      'imageUrl': imageUrl,
      'userName': userName,
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    final List<Comment> comments = (json['comments'] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];

    return Post(
      text: json['text'],
      userId: json['userId'],
      id: json['id'],
      timStamp: (json['timStamp'] as Timestamp).toDate(),
      imageUrl: json['imageUrl'],
      userName: json['userName'],
      likes: List<String>.from(json['likes'] ?? []),
      comments: comments
    );
  }
}
