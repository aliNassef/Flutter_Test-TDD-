import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_course/datasource/remote_datasource.dart';
import 'package:tdd_course/models/post_model.dart';
import 'package:tdd_course/repo/posts_repo_impl.dart';

import 'posts_repo_impl_test.mocks.dart';

@GenerateMocks([RemoteDatasourceImpl])
void main() {
  late RemoteDatasource remoteDatasource;
  late PostsRepoImpl postsRepo;
  setUp(() {
    remoteDatasource = MockRemoteDatasourceImpl();
    postsRepo = PostsRepoImpl(datasource: remoteDatasource);
  });

  test(
    'should get list of posts model without any exceptions ',
    () async {
      // arrange
      final posts = List.generate(
        5,
        (index) => PostModel(
            userId: index, id: index, title: 'title $index', body: '$index'),
      );

      when(remoteDatasource.getPosts()).thenAnswer((_) => Future.value(posts));

      // act
      final res = await postsRepo.getPosts();
      expect(res, posts);
    },
  );

  test(
    'should return exception when get posts fails',
    () async {
      // بعمل موك للحاجه اللى هتتنادى وارجع اللى على مزاجى
      when(remoteDatasource.getPosts()).thenAnswer(
        (_) => throw Exception(),
      );
      res() async => await postsRepo.getPosts();
      expect(res, throwsA(isA<Exception>()));
    },
  );
}
