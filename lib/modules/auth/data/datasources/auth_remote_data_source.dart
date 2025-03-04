import 'package:auth/core/network/api_client.dart';
import 'package:auth/modules/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post("/login", {"email": email, "password": password});
    return UserModel.fromJson(response);
  }

  Future<UserModel> signup(String username, String email, String password) async {
    final response = await apiClient.post("/signup", {"username": username, "email": email, "password": password});
    return UserModel.fromJson(response);
  }
}
