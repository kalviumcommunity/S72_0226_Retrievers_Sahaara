# Contributing to Sahara

Thank you for your interest in contributing to Sahara! This document provides guidelines and instructions for contributing to the project.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Expected Behavior

- Be respectful and considerate
- Accept constructive criticism gracefully
- Focus on what's best for the project
- Show empathy towards other contributors

### Unacceptable Behavior

- Harassment or discriminatory language
- Personal attacks or trolling
- Publishing others' private information
- Any conduct that could be considered unprofessional

---

## Getting Started

### Prerequisites

Before contributing, ensure you have:

1. Completed the [Setup Guide](docs/SETUP_GUIDE.md)
2. Read the [Architecture Documentation](docs/ARCHITECTURE.md)
3. Familiarized yourself with the [Database Schema](docs/DATABASE_SCHEMA.md)
4. Set up your development environment

### Finding Issues to Work On

1. Check the [Issues](https://github.com/team-retrievers/Sahara/issues) page
2. Look for issues labeled `good first issue` or `help wanted`
3. Comment on the issue to express your interest
4. Wait for assignment before starting work

---

## Development Workflow

### 1. Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/Sahara.git
cd Sahara

# Add upstream remote
git remote add upstream https://github.com/team-retrievers/Sahara.git
```

### 2. Create a Branch

```bash
# Update your local main branch
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/bug-description
```

### 3. Make Changes

- Write clean, readable code
- Follow the coding standards (see below)
- Add comments where necessary
- Update documentation if needed

### 4. Test Your Changes

```bash
# Run tests
flutter test

# Check for errors
flutter analyze

# Format code
flutter format lib/
```

### 5. Commit Your Changes

```bash
# Stage your changes
git add .

# Commit with a descriptive message
git commit -m "Add: user authentication feature"
```

### 6. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 7. Create Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Select your branch
4. Fill in the PR template
5. Submit for review

---

## Coding Standards

### Dart/Flutter Style Guide

Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines:

#### Naming Conventions

```dart
// Classes: UpperCamelCase
class UserProfile {}

// Variables and functions: lowerCamelCase
String userName = 'John';
void fetchUserData() {}

// Constants: lowerCamelCase
const int maxRetries = 3;

// Private members: prefix with underscore
String _privateVariable;
void _privateMethod() {}
```

#### File Organization

```dart
// 1. Imports (grouped and sorted)
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

// 2. Class definition
class MyWidget extends StatelessWidget {
  // 3. Constructor
  const MyWidget({super.key});
  
  // 4. Properties
  final String title = 'Title';
  
  // 5. Methods
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

#### Code Formatting

```dart
// Use trailing commas for better formatting
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Hello'),
        Text('World'),
      ],
    ),
  );
}

// Prefer const constructors
const SizedBox(height: 16)

// Use named parameters for clarity
fetchUser(
  userId: '123',
  includeProfile: true,
)
```

### Widget Guidelines

#### Prefer StatelessWidget

```dart
// Good
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Text('Hello');
  }
}

// Use StatefulWidget only when state is needed
class Counter extends StatefulWidget {
  const Counter({super.key});
  
  @override
  State<Counter> createState() => _CounterState();
}
```

#### Extract Widgets

```dart
// Bad: Large build method
Widget build(BuildContext context) {
  return Column(
    children: [
      Container(
        // 50 lines of code
      ),
      Container(
        // 50 lines of code
      ),
    ],
  );
}

// Good: Extracted widgets
Widget build(BuildContext context) {
  return Column(
    children: [
      _buildHeader(),
      _buildContent(),
    ],
  );
}

Widget _buildHeader() {
  return Container(/* ... */);
}
```

### Error Handling

```dart
// Always handle errors
try {
  await fetchData();
} on FirebaseException catch (e) {
  print('Firebase error: ${e.message}');
  // Show user-friendly error
} catch (e) {
  print('Unexpected error: $e');
  // Show generic error
}

// Use custom exceptions
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
```

### Async/Await

```dart
// Good: Use async/await
Future<void> fetchData() async {
  try {
    final data = await repository.getData();
    processData(data);
  } catch (e) {
    handleError(e);
  }
}

// Avoid: Nested then() calls
repository.getData().then((data) {
  processData(data);
}).catchError((e) {
  handleError(e);
});
```

---

## Commit Guidelines

### Commit Message Format

```
Type: Brief description (max 50 characters)

Detailed explanation if needed (wrap at 72 characters)

Fixes #123
```

### Commit Types

- `Add:` New feature or functionality
- `Fix:` Bug fix
- `Update:` Update existing feature
- `Refactor:` Code refactoring
- `Docs:` Documentation changes
- `Style:` Code style changes (formatting, etc.)
- `Test:` Add or update tests
- `Chore:` Maintenance tasks

### Examples

```bash
# Good commits
git commit -m "Add: user authentication with Firebase Auth"
git commit -m "Fix: null pointer exception in booking list"
git commit -m "Update: improve caregiver search performance"
git commit -m "Docs: add setup instructions for iOS"

# Bad commits
git commit -m "fixed stuff"
git commit -m "updates"
git commit -m "asdfasdf"
```

---

## Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] No analyzer warnings
- [ ] Code is formatted (`flutter format`)
- [ ] Documentation is updated
- [ ] Commits are clean and descriptive

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How has this been tested?

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests pass
- [ ] Documentation updated
```

### Review Process

1. **Automated Checks**: CI/CD runs tests and linting
2. **Code Review**: Team members review your code
3. **Feedback**: Address any requested changes
4. **Approval**: At least one approval required
5. **Merge**: Maintainer merges your PR

---

## Testing

### Unit Tests

```dart
// test/models/user_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:Sahara/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create user from JSON', () {
      final json = {
        'userId': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
      };
      
      final user = UserModel.fromJson(json);
      
      expect(user.userId, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
    });
  });
}
```

### Widget Tests

```dart
// test/widgets/caregiver_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Sahara/widgets/caregiver_card.dart';

void main() {
  testWidgets('CaregiverCard displays caregiver info', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CaregiverCard(
            caregiver: mockCaregiver,
          ),
        ),
      ),
    );
    
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsWidgets);
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/user_model_test.dart

# Run with coverage
flutter test --coverage
```

---

## Documentation

### Code Comments

```dart
/// Fetches user data from Firestore
///
/// Returns [UserModel] if successful, throws [Exception] on error
///
/// Example:
/// ```dart
/// final user = await fetchUser('user123');
/// ```
Future<UserModel> fetchUser(String userId) async {
  // Implementation
}
```

### README Updates

When adding new features, update:
- Feature list in README.md
- Setup instructions if needed
- Usage examples

### Architecture Documentation

For significant changes, update:
- docs/ARCHITECTURE.md
- docs/DATABASE_SCHEMA.md
- Add diagrams if helpful

---

## Questions?

If you have questions:

1. Check existing documentation
2. Search closed issues
3. Ask in team chat
4. Create a new issue with `question` label

---

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

Thank you for contributing to Sahara! 🐾
