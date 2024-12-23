
import 'app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String imagePathUrl;

  ProfileUser({
    required this.bio,
    required this.imagePathUrl,
    required super.email,
    required super.name,
    required super.userId,
  });

  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageUrl,
  }) {
    return ProfileUser(
      bio: newBio ?? bio,
      imagePathUrl: newProfileImageUrl ?? imagePathUrl,
      email: email,
      name: name,
      userId: userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'imagePathUrl': imagePathUrl,
      'email': email,
      'name': name,
      'userId': userId,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      bio: json['bio']??'',
      imagePathUrl: json['imagePathUrl']??'',
      email: json['email'],
      name: json['name'],
      userId: json['userId'],
    );
  }
}
