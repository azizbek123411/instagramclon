import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timStamp;
  final List<String> likes;

  Post({
    required this.text,
    required this.userId,
    required this.id,
    required this.timStamp,
    required this.imageUrl,
    required this.userName,
    required this.likes
  });

  Post copyWith({String? imageUrl}) {
    return Post(
      text: text,
      userId: userId,
      id: id,
      timStamp: timStamp,
      imageUrl: imageUrl ?? this.imageUrl,
      userName: userName,
      likes: likes
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'userId': userId,
      'id': id,
      'timStamp': Timestamp.fromDate(timStamp),
      'imageUrl': imageUrl,
      'userName': userName,
      'likes':likes
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      text: json['text'],
      userId: json['userId'],
      id: json['id'],
      timStamp: (json['timStamp'] as Timestamp).toDate(),
      imageUrl: json['imageUrl'],
      userName: json['userName'],
      likes: List<String>.from(json['likes']??[]),
    );
  }
}
