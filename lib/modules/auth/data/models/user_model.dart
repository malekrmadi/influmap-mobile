import 'package:auth/modules/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String username,
    required String email,
    required String token,
    required String avatar,
    required String bio,
    required int level,
    required List<String> badges,
  }) : super(
          id: id,
          username: username,
          email: email,
          token: token,
          avatar: avatar,
          bio: bio,
          level: level,
          badges: badges,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? "", // L'ID est stocké sous "_id"
      username: json['username'] ?? "Inconnu",
      email: json['email'] ?? "Aucun email",
      token: json['token'] ?? "", // Le token est parfois hors de l'objet "user"
      avatar: json['avatar'] ?? "",
      bio: json['bio'] ?? "",
      level: json['level'] ?? 0,
      badges: (json['badges'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
