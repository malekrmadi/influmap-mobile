import '../models/user_model.dart';

abstract class UserRepository {
  Future<List<User>> getAllUsers();
  Future<User> getUserById(String id);
} 