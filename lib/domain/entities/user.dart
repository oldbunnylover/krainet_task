import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String? email;
  final String? username;
  final DateTime? dateOfBirth;

  const User({
    required this.id,
    this.email,
    this.username,
    this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['uid'],
      email: json['email'],
      username: json['username'],
      dateOfBirth: DateTime.fromMicrosecondsSinceEpoch((json['date_of_birth'] as Timestamp).microsecondsSinceEpoch),
    );
  }

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
}

class UserCredentials {
  final String email;
  final String password;
  final String? username;
  final DateTime? dateOfBirth;

  UserCredentials({
    required this.email,
    required this.password,
    this.username,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'username': username,
      'date_of_birth': dateOfBirth,
    };
  }
}
