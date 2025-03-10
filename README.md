# Flutter TDD - Posts Application

A sample Flutter application built using Test-Driven Development (TDD) principles. This project serves as a learning resource for understanding how to implement TDD in Flutter applications, along with Clean Architecture and BLoC/Cubit for state management.

## 📚 About Test-Driven Development (TDD)

Test-Driven Development is a software development approach where tests are written before the actual code. The TDD cycle consists of three steps:

1. **Red**: Write a failing test for the functionality you want to implement
2. **Green**: Write the minimum amount of code to make the test pass
3. **Refactor**: Improve the code while keeping the tests passing

This project demonstrates how to apply TDD principles in a Flutter application, focusing on:
- Writing unit tests for business logic
- Implementing the code based on tests
- Separating concerns using Clean Architecture
- Managing state with BLoC/Cubit pattern

## 🌟 Features

- ✅ Display a list of posts with an attractive design
- ✅ View post details when clicked
- ✅ Pull to refresh
- ✅ Handle loading and error states
- ✅ Support for dark and light themes
- ✅ Responsive design that works on various screen sizes

## 🧪 TDD Implementation

This project follows TDD principles in the following ways:

### 1. Test First Approach
All features were implemented by first writing tests that define the expected behavior, then implementing the code to satisfy those tests.

### 2. Testing Layers
- **Unit Tests**: Testing individual components (Cubit, Repository, Data Source, etc.)

### 3. Example TDD Workflow

For the Posts feature, we followed this workflow:
1. Wrote tests for the `RemoteDatasource` to define how it should fetch data from the API
2. Implemented the `RemoteDatasource` to satisfy the tests
3. Wrote tests for the `PostsRepo` to define how it should interact with the data source
4. Implemented the `PostsRepo` to satisfy the tests
5. Wrote tests for the `PostsCubit` to define how it should handle loading posts
6. Implemented the `PostsCubit` to satisfy the tests
7. Created the UI components after the business logic was tested and implemented

## 🏗️ Project Structure

The project follows Clean Architecture with separation between layers:

```
lib/
├── core/                  # Core components and shared services
│   ├── services/          # Services like network service
│   └── theme/             # App themes
├── cubit/                 # State management components using Cubit
├── datasource/            # Data sources (local or remote)
├── models/                # Data models
├── presentation/          # UI and screens
│   ├── post_page.dart     # Posts list page
│   └── post_details_page.dart # Post details page
├── repo/                  # Repository layer
└── main.dart              # App entry point
```

## 🧪 Tests

The project contains comprehensive unit tests to ensure code quality across all layers:

```
test/
├── cubit/                 # Tests for Cubit components
│   └── posts_cubit_test.dart # Test for PostsCubit
├── datasource/            # Tests for data sources
│   └── remote_datasource_test.dart # Test for RemoteDatasource
└── repo/                  # Tests for repositories
    └── posts_repo_impl_test.dart # Test for PostsRepoImpl
```

### Testing the Data Source Layer

The `RemoteDatasource` is responsible for fetching data from the API. We test:
- Successful data retrieval and parsing
- Error handling for non-200 status codes

Example test:
```dart
test(
  'get posts should return posts without any exceptions',
  () async {
    // Arrange: Mock the network service response
    when(networkService.get('https://jsonplaceholder.typicode.com/posts'))
        .thenAnswer((_) => Future.value(
          Response(
            requestOptions: RequestOptions(path: '...'),
            data: postsMap,
            statusCode: 200,
          ),
        ));
    
    // Act: Call the method being tested
    final res = await remoteDatasource.getPosts();

    // Assert: Verify the result matches expectations
    expect(res, posts);
  },
);
```

### Testing the Repository Layer

The `PostsRepo` acts as a mediator between the data source and the business logic. We test:
- Successful data retrieval from the data source
- Proper error propagation

Example test:
```dart
test(
  'should get list of posts model without any exceptions',
  () async {
    // Arrange: Mock the data source response
    when(remoteDatasource.getPosts()).thenAnswer((_) => Future.value(posts));

    // Act: Call the method being tested
    final res = await postsRepo.getPosts();
    
    // Assert: Verify the result matches expectations
    expect(res, posts);
  },
);
```

## 🛠️ Technologies Used

- **Flutter**: Framework for building cross-platform applications
- **Bloc/Cubit**: For state management
- **Clean Architecture**: Design pattern for separating application layers
- **Mockito**: For creating mock objects in tests
- **Equatable**: For easy comparison between objects
- **bloc_test**: For testing BLoC/Cubit components
- **Dio**: For making HTTP requests

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (2.0.0 or newer)
- Dart SDK (2.12.0 or newer)
- Any text editor (VS Code, Android Studio, etc.)

### Installation

1. Clone the project:
```bash
git clone https://github.com/yourusername/tdd_course.git
cd tdd_course
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the tests:
```bash
flutter test
```

4. Run the app:
```bash
flutter run
```

## 📱 Screenshots
<p float="left">
+   <img src="screenshots/Screenshot 2025-03-10 043412.png" width="300" alt="Light Mode" />
+   <img src="screenshots\Screenshot 2025-03-10 043427.png" width="300" alt="Dark Mode" /> 
+ </p>
 
### BLoC/Cubit Pattern

The application uses the BLoC/Cubit pattern for state management, where:

- **PostsCubit**: Manages the state of the posts list (loading, success, failure)
- **PostsState**: Represents the different states of the application (initial, loading, loaded, failure)
 