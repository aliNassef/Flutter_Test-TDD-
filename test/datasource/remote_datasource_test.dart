import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_course/core/services/network_service.dart';
import 'package:tdd_course/datasource/remote_datasource.dart';
import 'package:tdd_course/models/post_model.dart';

import 'remote_datasource_test.mocks.dart';

@GenerateMocks([NetworkService])
void main() {
  late RemoteDatasourceImpl remoteDatasource;
  late NetworkService networkService;
  // run before test run & every test create new obj
  setUp(() {
    networkService = MockNetworkService();
    remoteDatasource = RemoteDatasourceImpl(networkService: networkService);
  });

  test(
    'get posts should return posts without any exceptions',
    () async {
      //arrange
      final posts = List.generate(
          5,
          (index) => PostModel(
              id: index,
              userId: index,
              title: 'title $index',
              body: 'body $index'));

      final postsMap = posts.map((post) => post.toMap()).toList();
      when(networkService.get('https://jsonplaceholder.typicode.com/posts'))
          .thenAnswer(
        (_) => Future.value(
          Response(
            requestOptions: RequestOptions(
                path: 'https://jsonplaceholder.typicode.com/posts'),
            data: postsMap,
            statusCode: 200,
          ),
        ),
      );
      //act
      final res = await remoteDatasource.getPosts();

      // assert
      expect(res, posts);
    },
  );

  test(
    'should throw  an exception when the status code is not 200',
    () async {
      // arrange
      when(networkService.get('https://jsonplaceholder.typicode.com/posts'))
          .thenAnswer(
        (_) => Future.value(
          Response(
            requestOptions: RequestOptions(
                path: 'https://jsonplaceholder.typicode.com/posts'),
            statusCode: 404,
          ),
        ),
      );
      // act
      res() async => await remoteDatasource.getPosts();

      expect(
        res,
        throwsA(isA<Exception>()),
      );
    },
  );



  
}
