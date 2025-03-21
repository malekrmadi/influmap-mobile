import '../../domain/models/post_model.dart';
import '../../../../core/network/api_client.dart';

class PostRemoteDataSource {
  final ApiClient _apiClient;

  PostRemoteDataSource(this._apiClient);

  /// 📌 Récupérer tous les posts
  Future<List<Post>> getAllPosts() async {
    try {
      final response = await _apiClient.getAllPosts();
      if (response is List) {
        return response.map((json) => _handleNullValues(Post.fromJson(json as Map<String, dynamic>))).toList();
      } else {
        throw Exception("❌ Unexpected response format for posts");
      }
    } catch (e) {
      throw Exception('❌ Failed to fetch posts: $e');
    }
  }

  /// 📌 Récupérer un post par ID
  Future<Post> getPostById(String id) async {
    try {
      final response = await _apiClient.get('/posts/$id');
      if (response is Map<String, dynamic>) {
        return _handleNullValues(Post.fromJson(response));
      } else {
        throw Exception("❌ Unexpected response format for a single post");
      }
    } catch (e) {
      throw Exception('❌ Failed to fetch post: $e');
    }
  }

  /// 📌 Fonction pour éviter les valeurs nulles
  Post _handleNullValues(Post post) {
    return Post(
      userId: (post.userId.isNotEmpty) ? post.userId : 'default_user',
      placeId: (post.placeId.isNotEmpty) ? post.placeId : 'default_place',
      type: post.type,
      media: post.media,
      text: post.text,
      expiresAt: post.expiresAt,
    );
  }
}
