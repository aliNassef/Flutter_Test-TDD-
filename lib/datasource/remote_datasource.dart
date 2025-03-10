import '../core/services/network_service.dart';
import '../models/post_model.dart';

abstract class RemoteDatasource {
  Future<List<PostModel>> getPosts();
}

class RemoteDatasourceImpl extends RemoteDatasource {
  final NetworkService _networkService;

  RemoteDatasourceImpl({required NetworkService networkService})
      : _networkService = networkService;

  @override
  Future<List<PostModel>> getPosts() async {
    final response =
        await _networkService.get('https://jsonplaceholder.typicode.com/posts');
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch posts');
    }
    final List<dynamic> res = response.data;
    final posts = res
        .map((post) => PostModel.fromMap(post as Map<String, dynamic>))
        .toList();
    return posts;
  }
}
