import '../models/post_model.dart';

abstract class PostRepository {
  Future<List<Post>> getAllPosts();
  Future<Post> getPostById(String id);
} 