import '../../domain/models/post_model.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      final posts = await remoteDataSource.getAllPosts();
      return posts.map((post) => _handleNullValues(post)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des posts: $e');
    }
  }

  @override
  Future<Post> getPostById(String id) async {
    try {
      final post = await remoteDataSource.getPostById(id);
      return _handleNullValues(post);
    } catch (e) {
      throw Exception('Erreur lors de la récupération du post: $e');
    }
  }

  // Fonction pour éviter les valeurs nulles
  Post _handleNullValues(Post post) {
    return Post(
      userId: post.userId.isNotEmpty ? post.userId : 'default_user',
      placeId: post.placeId.isNotEmpty ? post.placeId : 'default_place',
      type: post.type,
      media: post.media,
      text: post.text,
      expiresAt: post.expiresAt,
    );
  }
}
