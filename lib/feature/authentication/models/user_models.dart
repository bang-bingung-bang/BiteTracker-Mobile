////lib\feature\authentication\models\user_models.dart

import 'dart:convert';

late User? logInUser;

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String username;
  int userId;
  String email;
  bool role;
  String message;

  User({
    required this.username,
    required this.userId,
    required this.email,
    required this.role,
    required this.message,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json["username"],
    userId: json["user_id"],
    email: json["email"],
    role: json["role"],
    message: json["message"],
  );
  
  Map<String, dynamic> toJson() => {
    "username": username,
    "user_id": userId,
    "email": email,
    "role": role,
    "message": message,
  };
}