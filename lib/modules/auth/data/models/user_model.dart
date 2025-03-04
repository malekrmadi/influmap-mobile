import 'package:auth/modules/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String username,
    required String email,
    required String token,
  }) : super(id: id, username: username, email: email, token: token);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      token: json['token'],
    );
  }
}
