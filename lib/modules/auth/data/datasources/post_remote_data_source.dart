import '../../domain/models/post_model.dart';
import '../../../../core/network/api_client.dart';

class PostRemoteDataSource {
  final ApiClient _apiClient;

  PostRemoteDataSource(this._apiClient);

  Future<List<Post>> getAllPosts() async {
    try {
      final response = await _apiClient.get('/posts');
      return (response.data as List)
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<Post> getPostById(String id) async {
    try {
      final response = await _apiClient.get('/posts/$id');
      return Post.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch post: $e');
    }
  }
} 