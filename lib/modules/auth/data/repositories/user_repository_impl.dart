//import 'dart:convert';
//import 'package:http/http.dart' as http;
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  
  UserRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<List<User>> getAllUsers() async {
    try {
      return await remoteDataSource.getAllUsers();
    } catch (e) {
      // For development, return mock data if API is not available
      return _getMockUsers();
    }
  }
  
  @override
  Future<User> getUserById(String id) async {
    try {
      return await remoteDataSource.getUserById(id);
    } catch (e) {
      // For development, return mock data if API is not available
      return _getMockUsers().firstWhere((user) => user.id == id, 
        orElse: () => _getMockUsers().first);
    }
  }
  
  // Mock data for development
  List<User> _getMockUsers() {
    return List.generate(10, (index) => User(
      id: '67c520685714141058${index}d993b',
      username: 'user${index + 1}',
      email: 'user${index + 1}@example.com',
      bio: 'Bio for user ${index + 1}',
      avatar: 'https://example.com/avatar${index + 1}.jpg',
      level: 1 + (index % 5),
      badges: ['badge1', 'badge2'],
      followersCount: 100 + (index * 10),
      followingCount: 50 + (index * 5),
    ));
  }
} 