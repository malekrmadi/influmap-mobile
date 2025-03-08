import 'package:auth/core/network/api_client.dart';
import 'package:auth/modules/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.login(email, password);

    if (response.containsKey('user')) {
      final user = UserModel.fromJson(response['user']);
      return UserModel(
        id: user.id,
        username: user.username,
        email: user.email,
        token: response['token'] ?? "", // Ajout du token manuellement
        avatar: user.avatar,
        bio: user.bio,
        level: user.level,
        badges: user.badges,
      );
    } else {
      throw Exception("Format de réponse invalide: $response");
    }
  }

  Future<UserModel> signup(String username, String email, String password, String avatar, String bio ,int level ,List<String> badges) async {
    final response = await apiClient.signup(username, email, password, avatar, bio);

    if (response.containsKey('user')) {
      final user = UserModel.fromJson(response['user']);
      return user;
    } else {
      throw Exception("Format de réponse invalide: $response");
    }
  }
}
