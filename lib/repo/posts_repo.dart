import '../models/post_model.dart';

abstract class PostsRepo {
  Future<List<PostModel>> getPosts();
}
