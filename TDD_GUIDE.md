# Test-Driven Development (TDD) Guide for Flutter

This guide explains the principles of Test-Driven Development (TDD) and how to apply them in Flutter projects, with practical examples from this project.

## What is TDD?

Test-Driven Development is a software development methodology where you write tests before writing the actual code. The TDD cycle consists of three phases, often referred to as "Red-Green-Refactor":

1. **Red**: Write a failing test for the functionality you want to implement
2. **Green**: Write the minimum amount of code to make the test pass
3. **Refactor**: Improve the code while keeping the tests passing

## Benefits of TDD

- **Higher code quality**: Writing tests first forces you to think about the design and requirements before implementation
- **Better code coverage**: Since tests are written first, all code is covered by tests
- **Easier refactoring**: Tests provide a safety net when refactoring code
- **Documentation**: Tests serve as documentation for how the code should behave
- **Fewer bugs**: TDD helps catch bugs early in the development process

## TDD in Flutter

Flutter provides excellent support for testing through its testing framework. There are three main types of tests in Flutter:

1. **Unit Tests**: Test individual functions, methods, or classes
2. **Widget Tests**: Test UI components
3. **Integration Tests**: Test the entire application or large parts of it

This project focuses primarily on unit tests for the business logic, following Clean Architecture principles.

## TDD Workflow Example

Let's walk through a practical example from this project: implementing the `PostsCubit` using TDD.

### Step 1: Write a Failing Test

First, we write a test for the `PostsCubit` that defines how it should behave when loading posts:

```dart
// test/cubit/posts_cubit_test.dart
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
```

This test defines that:
- When `loadPosts()` is called
- The cubit should emit a `PostsLoading` state followed by a `PostsLoaded` state
- The `getPosts()` method of the repository should be called once

### Step 2: Implement the Code

Next, we implement the minimum code to make the test pass:

```dart
// lib/cubit/posts_cubit.dart
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

### Step 3: Write a Test for Error Handling

Now, let's write a test for the error case:

```dart
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
```

### Step 4: Refactor if Needed

Our implementation already handles errors, so no additional code is needed. If we wanted to refactor, we could do so while ensuring the tests still pass.

## Testing Different Layers

### Repository Layer

For the repository layer, we test that it correctly interacts with the data source:

```dart
test('getPosts should return a list of posts from the data source', () async {
  // Arrange
  when(dataSource.getPosts()).thenAnswer((_) async => testPostsData);
  
  // Act
  final result = await postsRepo.getPosts();
  
  // Assert
  expect(result, equals(testPosts));
  verify(dataSource.getPosts()).called(1);
});
```

 
## Best Practices for TDD in Flutter

1. **Start with a failing test**: Always begin by writing a test that fails
2. **Keep tests simple**: Each test should verify a single behavior
3. **Use descriptive test names**: Test names should describe the expected behavior
4. **Mock dependencies**: Use mocks to isolate the component being tested
5. **Test edge cases**: Include tests for error conditions and edge cases
6. **Refactor regularly**: Continuously improve your code while keeping tests passing
7. **Maintain test independence**: Tests should not depend on each other

## Tools for TDD in Flutter

- **flutter_test**: Flutter's built-in testing framework
- **bloc_test**: For testing BLoC/Cubit components
- **mockito**: For creating mock objects
- **build_runner**: For generating mock classes
- **equatable**: For easy comparison of objects in tests

 