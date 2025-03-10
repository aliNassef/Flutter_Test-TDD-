# Contributing to Flutter TDD Course

Thank you for your interest in contributing to the Flutter TDD Course project! This document provides guidelines and instructions for contributing.

## TDD Principles

This project follows Test-Driven Development (TDD) principles. When contributing, please adhere to the following workflow:

1. **Write Tests First**: Before implementing any feature or fixing any bug, write tests that define the expected behavior.
2. **Run Tests (Red)**: Ensure that the tests fail initially, confirming that they're testing something that doesn't exist yet.
3. **Implement Code (Green)**: Write the minimum amount of code necessary to make the tests pass.
4. **Refactor**: Improve the code while ensuring that tests continue to pass.
5. **Commit**: Commit your changes with a descriptive message.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/tdd_course.git
   cd tdd_course
   ```
3. Set up the upstream remote:
   ```bash
   git remote add upstream https://github.com/original-owner/tdd_course.git
   ```
4. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### 1. Understanding the Project Structure

Before making changes, familiarize yourself with the project structure:
- `lib/`: Contains the source code
- `test/`: Contains the test files
- Each feature should have corresponding test files

### 2. Writing Tests

- Place test files in the appropriate directory under `test/`
- Name test files with the `_test.dart` suffix
- Use descriptive test names that explain the expected behavior
- For Cubit/BLoC tests, use the `bloc_test` package
- For mocking dependencies, use the `mockito` package

Example of a test file:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
// Import your files

void main() {
  group('YourFeature', () {
    test('should do something specific', () {
      // Arrange
      // Act
      // Assert
    });
    
    blocTest<YourCubit, YourState>(
      'should emit states in the correct order',
      build: () => YourCubit(),
      act: (cubit) => cubit.doSomething(),
      expect: () => [
        YourLoadingState(),
        YourLoadedState(),
      ],
    );
  });
}
```

### 3. Implementing Code

After writing tests, implement the code to make them pass:
- Follow the Clean Architecture principles
- Keep classes and methods focused on a single responsibility
- Use dependency injection for better testability
- Ensure your code passes all existing tests

### 4. Running Tests

Run tests to ensure your implementation works:
```bash
flutter test
```

For specific test files:
```bash
flutter test test/path/to/your_test.dart
```

### 5. Code Style

Follow the [Dart style guide](https://dart.dev/guides/language/effective-dart/style) and ensure your code is formatted:
```bash
dart format .
```

## Pull Request Process

1. Ensure your code passes all tests
2. Update the README.md if necessary
3. Push your changes to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
4. Create a Pull Request against the main repository
5. In your PR description:
   - Describe the changes you've made
   - Reference any related issues
   - Explain how you've tested your changes
   - Mention any breaking changes

## Adding New Features

When adding new features:
1. Create tests for the new feature
2. Implement the feature following TDD principles
3. Update documentation as necessary
4. Consider adding example usage

## Reporting Issues

When reporting issues, please include:
- A clear description of the issue
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots if applicable
- Environment information (Flutter version, device, etc.)

## Code of Conduct

Please be respectful and considerate of others when contributing. We aim to foster an inclusive and welcoming community.

## Questions?

If you have any questions about contributing, feel free to open an issue for discussion.

Thank you for contributing to the Flutter TDD Course project! 