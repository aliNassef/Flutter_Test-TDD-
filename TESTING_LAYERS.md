# Testing Different Layers in Flutter with TDD

This guide explains how to test different layers of a Flutter application using Test-Driven Development (TDD) principles, with a focus on the data source and repository layers.

## Understanding the Layers

In Clean Architecture, an application is typically divided into several layers:

1. **Presentation Layer**: UI components and state management (Widgets, BLoC/Cubit)
2. **Domain Layer**: Business logic and use cases
3. **Data Layer**: Data handling, which includes:
   - **Repository**: Mediates between data sources and the domain layer
   - **Data Source**: Handles data retrieval from external sources (API, database)

## Testing the Data Source Layer

The data source layer is responsible for fetching data from external sources like APIs or databases. In our application, we have a `RemoteDatasource` that fetches posts from a REST API.

### Step 1: Define the Test Cases

Before implementing the data source, we define what we want to test:

1. Successful data retrieval and parsing
2. Error handling for non-200 status codes

### Step 2: Write the Tests

```dart
// test/datasource/remote_datasource_test.dart

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
  
  setUp(() {
    networkService = MockNetworkService();
    remoteDatasource = RemoteDatasourceImpl(networkService: networkService);
  });

  test(
    'get posts should return posts without any exceptions',
    () async {
      // Arrange: Prepare test data and mock responses
      final posts = List.generate(
          5,
          (index) => PostModel(
              id: index,
              userId: index,
              title: 'title $index',
              body: 'body $index'));

      final postsMap = posts.map((post) => post.toMap()).toList();
      
      // Mock the network service to return a successful response
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
      
      // Act: Call the method being tested
      final res = await remoteDatasource.getPosts();

      // Assert: Verify the result matches expectations
      expect(res, posts);
    },
  );

  test(
    'should throw an exception when the status code is not 200',
    () async {
      // Arrange: Mock the network service to return an error response
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
      
      // Act & Assert: Verify that calling the method throws an exception
      expect(
        () => remoteDatasource.getPosts(),
        throwsA(isA<Exception>()),
      );
    },
  );
}
```

### Step 3: Implement the Data Source

After writing the tests, we implement the data source to make the tests pass:

```dart
// lib/datasource/remote_datasource.dart

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
```

## Testing the Repository Layer

The repository layer acts as a mediator between the data sources and the domain layer. It decides which data source to use and handles any necessary transformations.

### Step 1: Define the Test Cases

Before implementing the repository, we define what we want to test:

1. Successful data retrieval from the data source
2. Proper error propagation

### Step 2: Write the Tests

```dart
// test/repo/posts_repo_impl_test.dart

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
    'should get list of posts model without any exceptions',
    () async {
      // Arrange: Prepare test data and mock responses
      final posts = List.generate(
        5,
        (index) => PostModel(
            userId: index, id: index, title: 'title $index', body: '$index'),
      );

      // Mock the data source to return the test data
      when(remoteDatasource.getPosts()).thenAnswer((_) => Future.value(posts));

      // Act: Call the method being tested
      final res = await postsRepo.getPosts();
      
      // Assert: Verify the result matches expectations
      expect(res, posts);
    },
  );

  test(
    'should return exception when get posts fails',
    () async {
      // Arrange: Mock the data source to throw an exception
      when(remoteDatasource.getPosts()).thenThrow(Exception());
      
      // Act & Assert: Verify that calling the method throws an exception
      expect(
        () => postsRepo.getPosts(),
        throwsA(isA<Exception>()),
      );
    },
  );
}
```

### Step 3: Implement the Repository

After writing the tests, we implement the repository to make the tests pass:

```dart
// lib/repo/posts_repo_impl.dart

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
```

## Testing the Cubit Layer

The Cubit layer is responsible for managing the state of the application based on user interactions and data from the repository.

### Step 1: Define the Test Cases

Before implementing the Cubit, we define what we want to test:

1. Loading state followed by loaded state when data is retrieved successfully
2. Loading state followed by error state when an exception occurs

### Step 2: Write the Tests

```dart
// test/cubit/posts_cubit_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_course/cubit/posts_cubit.dart';
import 'package:tdd_course/models/post_model.dart';
import 'package:tdd_course/repo/posts_repo_impl.dart';

import 'posts_cubit_test.mocks.dart';

@GenerateMocks([PostsRepoImpl])
void main() {
  late PostsCubit postsCubit;
  late MockPostsRepoImpl postsRepo;
  late List<PostModel> testPosts;

  setUp(() {
    postsRepo = MockPostsRepoImpl();
    postsCubit = PostsCubit(postsRepo);
    testPosts = List.generate(
      5,
      (index) => PostModel(
          userId: index, id: index, title: 'title $index', body: '$index'),
    );
  });

  tearDown(() {
    postsCubit.close();
  });

  blocTest<PostsCubit, PostsState>(
    'should emit [PostsLoading, PostsLoaded] when loadPosts is called successfully',
    build: () {
      when(postsRepo.getPosts()).thenAnswer((_) async => testPosts);
      return postsCubit;
    },
    act: (cubit) => cubit.loadPosts(),
    expect: () => [
      PostsLoading(),
      PostsLoaded(posts: testPosts),
    ],
    verify: (_) {
      verify(postsRepo.getPosts()).called(1);
    },
  );

  blocTest<PostsCubit, PostsState>(
    'should emit [PostsLoading, PostsFailure] when loadPosts throws an exception',
    build: () {
      when(postsRepo.getPosts()).thenThrow(Exception('Error fetching posts'));
      return postsCubit;
    },
    act: (cubit) => cubit.loadPosts(),
    expect: () => [
      PostsLoading(),
      PostsFailure(error: 'Exception: Error fetching posts'),
    ],
    verify: (_) {
      verify(postsRepo.getPosts()).called(1);
    },
  );
}
```

### Step 3: Implement the Cubit

After writing the tests, we implement the Cubit to make the tests pass:

```dart
// lib/cubit/posts_cubit.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tdd_course/models/post_model.dart';
import 'package:tdd_course/repo/posts_repo.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this._postsRepo) : super(PostsInitial());
  final PostsRepo _postsRepo;
  
  void loadPosts() async {
    emit(PostsLoading());
    try {
      var posts = await _postsRepo.getPosts();
      emit(PostsLoaded(posts: posts));
    } catch (e) {
      emit(PostsFailure(error: e.toString()));
    }
  }
}
```

## Best Practices for Testing Layers

1. **Mock Dependencies**: Always mock dependencies to isolate the component being tested
2. **Test Edge Cases**: Include tests for error conditions and edge cases
3. **Use Descriptive Test Names**: Test names should describe the expected behavior
4. **Follow AAA Pattern**: Arrange, Act, Assert - structure your tests clearly
5. **Keep Tests Independent**: Tests should not depend on each other
6. **Test One Thing at a Time**: Each test should verify a single behavior

## Conclusion

Testing different layers of a Flutter application using TDD principles ensures that each component works as expected in isolation. By writing tests for the data source, repository, and Cubit layers, we can be confident that our application will handle data retrieval and state management correctly.

This approach also makes it easier to refactor and extend the application in the future, as any regressions will be caught by the tests. 