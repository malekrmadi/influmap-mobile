import '../../domain/models/post_model.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      return await remoteDataSource.getAllPosts();
    } catch (e) {
      // For development purposes, return mock data if API is unavailable
      return _getMockPosts();
    }
  }

  @override
  Future<Post> getPostById(String id) async {
    try {
      return await remoteDataSource.getPostById(id);
    } catch (e) {
      // For development purposes, return mock data if API is unavailable
      return _getMockPost(id);
    }
  }

  List<Post> _getMockPosts() {
    return [
      _getMockPost('1'),
      _getMockPost('2'),
      _getMockPost('3'),
    ];
  }

  Post _getMockPost(String id) {
    return Post(
      userId: 'user_$id',
      placeId: 'place_$id',
      type: 'Story',
      media: ['assets/images/post.png'],
      text: 'Superbe coucher de soleil ici !',
      expiresAt: DateTime.now().add(const Duration(days: 1)),
    );
  }
} 