
import 'app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String imagePathUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUser({
    required this.bio,
    required this.imagePathUrl,
    required super.email,
    required super.name,
    required super.userId,
    required this.followers,
    required this.following
  });

  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newFollowers,
    List<String>? newFollowing,
  }) {
    return ProfileUser(
      bio: newBio ?? bio,
      imagePathUrl: newProfileImageUrl ?? imagePathUrl,
      email: email,
      name: name,
      userId: userId,
      followers: newFollowers??followers,
      following: newFollowing??following
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'imagePathUrl': imagePathUrl,
      'email': email,
      'name': name,
      'userId': userId,
      'followers':followers,
      'following':following,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      bio: json['bio']??'',
      imagePathUrl: json['imagePathUrl']??'',
      email: json['email'],
      name: json['name'],
      userId: json['userId'],
      followers: List<String>.from(json['followers']??[]),
      following: List<String>.from(json['following']??[]),
    );
  }
}
