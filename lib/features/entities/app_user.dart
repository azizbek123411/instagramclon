class AppUser {
  final String userId;
  final String email;
  final String name;

  AppUser({
    required this.email,
    required this.name,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'userId': userId,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      email: jsonUser['email'],
      name: jsonUser['name'],
      userId: jsonUser['userId'],
    );
  }
}
