// ignore_for_file: file_names

import 'package:challenge_one_project/enums.dart';

class UserModel {
  final int userId;
  final String firstName;
  final String lastName;
  final Role role;
  final String? teamName;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.teamName,
  });

  // Factory method to create a User from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: RoleExtension.fromString(json['role']),
      teamName: json['team_name'],
    );
  }
}
