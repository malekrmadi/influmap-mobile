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
      id: json['_id'] ?? "", // L'API utilise "_id" au lieu de "id"
      username: json['username'] ?? "Inconnu",
      email: json['email'] ?? "Aucun email",
      token: json['token'] ?? "", // Vérifier si l'API renvoie bien ce champ
    );
  }
}
