import 'package:tdd_course/models/post_model.dart';

abstract class LocalDatasource {
  Future<void> savePosts(List<PostModel> posts);
  Future<List<PostModel>> getPosts();
}

class LocalDatasourceImpl extends LocalDatasource {
  @override
  Future<List<PostModel>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }

  @override
  Future<void> savePosts(List<PostModel> posts) {
    // TODO: implement savePosts
    throw UnimplementedError();
  }
}
