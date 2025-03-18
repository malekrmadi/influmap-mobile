//import 'dart:convert';
import 'package:auth/core/network/api_client.dart';
import '../../domain/models/user_model.dart';

class UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSource(this._apiClient);

  Future<List<User>> getAllUsers() async {
    try {
      final List<dynamic> data = await _apiClient.getAllUsers();
      return data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<User> getUserById(String id) async {
    try {
      final dynamic data = await _apiClient.getUserById(id);
      return User.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }
} 