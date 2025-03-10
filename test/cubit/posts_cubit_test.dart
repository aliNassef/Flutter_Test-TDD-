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
  late PostsRepoImpl postsRepo;
  tearDown(() {
    postsCubit.close();
  });
  blocTest<PostsCubit, PostsState>(
    'posts cubit should emits loading then emits loaded state with a list of posts when calling loadPosts method',
    build: () => postsCubit,
    act: (cubit) => cubit.loadPosts(),
    setUp: () {
      postsRepo = MockPostsRepoImpl();
      postsCubit = PostsCubit(postsRepo);

      final posts = List.generate(
        5,
        (index) => PostModel(
            userId: index, id: index, title: 'title $index', body: '$index'),
      );
      when(postsRepo.getPosts()).thenAnswer((_) async => Future.value(posts));
    },
    expect: () {
      final posts = List.generate(
        5,
        (index) => PostModel(
            userId: index, id: index, title: 'title $index', body: '$index'),
      );
      return [
        PostsLoading(),
        PostsLoaded(posts: posts),
      ];
    },
  );

  blocTest<PostsCubit, PostsState>(
    'posts cubit should emits loading then emits Failure state with error message when calling loadPosts method',
    setUp: () {
      postsRepo = MockPostsRepoImpl();
      postsCubit = PostsCubit(postsRepo);
    },
    build: () {
      when(postsRepo.getPosts()).thenAnswer(
          (_) => throw Exception('An error occurred while loading posts.'));
      return postsCubit;
    },
    act: (cubit) => cubit.loadPosts(),
    expect: () => [
      PostsLoading(),
      PostsFailure(error: 'Exception: An error occurred while loading posts.'),
    ],
  );
}
