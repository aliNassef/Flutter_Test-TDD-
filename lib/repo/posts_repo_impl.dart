import 'package:tdd_course/datasource/remote_datasource.dart';
import 'package:tdd_course/models/post_model.dart';
import 'package:tdd_course/repo/posts_repo.dart';

class PostsRepoImpl extends PostsRepo {
  final RemoteDatasource _datasource;

  PostsRepoImpl({required RemoteDatasource datasource})
      : _datasource = datasource;

  @override
  Future<List<PostModel>> getPosts() async {
    return _datasource.getPosts();
  }
}
