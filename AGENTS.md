# AGENTS.md - Development Guidelines for Insurance Customer Portal

This document provides guidelines for agents working on the Insurance Customer Portal Flutter application.

## Project Overview

- **Framework**: Flutter (Latest Stable)
- **Target Platforms**: Android (API 30+), iOS (SDK 18.0+)
- **Languages**: English (EN) - Default, Bahasa Indonesia (ID) - Secondary
- **Architecture**: Clean Architecture with separation of concerns

## 1. Build, Lint, and Test Commands

### Running the Application

```bash
# Run the app in debug mode
flutter run

# Run on a specific device
flutter run -d <device_id>

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build for iOS (requires macOS)
flutter build ios --release
```

### Linting and Code Analysis

```bash
# Run Flutter analyzer
flutter analyze

# Run analyzer with fix suggestions
flutter analyze --fix

# Run Dart analyzer directly
dart analyze

# Format code
flutter format .
dart format .
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run a single test file
flutter test test/path/to/file_test.dart

# Run a single test by name (exact match)
flutter test --name "testName"

# Run a single test by name (pattern match)
flutter test --name "testName" --plain-name

# Run tests in debug mode with verbose output
flutter test --verbose

# Run tests with reporter
flutter test --reporter expanded
```

### Code Generation

```bash
# Generate code (e.g., freezed, json_serializable, build_runner)
dart run build_runner build

# Regenerate code on changes
dart run build_runner watch

# Clean and rebuild
flutter clean && flutter pub get && dart run build_runner build
```

### Dependency Management

```bash
# Install dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Get outdated packages
flutter pub outdated

# Add a dependency
flutter pub add <package_name>

# Add a dev dependency
flutter pub add --dev <package_name>
```

## 2. Code Style Guidelines

### General Principles

- Follow Clean Architecture: separate `core/`, `data/`, `domain/`, `presentation/`, and `utils/`
- Use meaningful, descriptive names for all identifiers
- Keep functions small and focused (single responsibility)
- Write self-documenting code; use comments sparingly and only for complex logic

### Project Structure

The project uses module-based organization for both BLoC and pages:

```plaintext
lib/
├── core/                    # Themes, constants, and configuration
│   ├── config/              # App configuration
│   ├── constants/          # App constants and API endpoints
│   └── theme/               # App themes (light/dark)
├── data/                    # Data layer
│   ├── datasources/         # API client
│   ├── models/              # Data models
│   └── repositories/         # Repository implementations
├── l10n/                    # Localization (ARB files)
├── presentation/           # UI layer
│   ├── bloc/                # BLoC state management (by module)
│   │   ├── auth/
│   │   ├── account/
│   │   └── product/
│   ├── pages/               # Screens (by module)
│   │   ├── auth/
│   │   ├── account/
│   │   ├── home/
│   │   ├── product/
│   │   ├── policy/
│   │   ├── proposal/
│   │   ├── illustration/
│   │   ├── claims/
│   │   ├── portfolio/
│   │   ├── notification/
│   │   └── app/
│   └── widgets/             # Shared widgets
└── main.dart
```

**Module Organization Rules:**
- Each feature/module has its own folder under `bloc/` and `pages/`
- Use singular names for folders (e.g., `account/`, not `accounts/`)
- Screen files: `{name}_screen.dart` or `{name}_page.dart`
- BLoC files: `{name}_bloc.dart`, `{name}_event.dart`, `{name}_state.dart`
- When adding new modules, create corresponding folders in both `bloc/` and `pages/`

### Dart/Flutter Conventions

#### File Naming

- Use `snake_case` for file names: `policy_tracker.dart`, `auth_controller.dart`
- One class per file (exceptions for tightly coupled classes)
- Suffix files with purpose: `_widget.dart`, `_controller.dart`, `_model.dart`, `_repository.dart`

#### Class and Type Names

- Use `PascalCase` for classes, enums, typedefs, and type parameters
- Use `CamelCase` for method and function names
- Prefix abstract classes with abstract descriptor if helpful: `abstract class PolicyRepository`

#### Variable and Constant Naming

- Use `camelCase` for variable and function arguments
- Use `kCamelCase` for constant values (Flutter convention)
- Use `SCREAMING_SNAKE_CASE` for enum values and static const
- Private members should be prefixed with underscore: `_privateVariable`

#### Imports

```dart
// Order: dart imports, package imports, relative imports
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:my_app/core/theme/app_theme.dart';
import 'package:my_app/domain/entities/policy.dart';
import '../presentation/widgets/common_widget.dart';
```

#### Formatting

- Maximum line length: 80 characters (Flutter default)
- Use trailing commas for better formatting
- Use `const` constructors wherever possible
- Always use curly braces for control structures, even single-line

```dart
// Good
const SizedBox(height: 16.0);
final policy = Policy(
  id: id,
  number: number,
  status: status,
);

// Avoid
var policy = Policy(id: id, number: number, status: status);
```

#### Types and Type Safety

- Enable strict type checking in analysis_options.yaml
- Avoid `dynamic` - use `Object?` or specific types
- Use type inference for local variables when type is obvious
- Prefer explicit return types for public methods

```dart
// Good
Future<Policy> fetchPolicy(String id) async {
  final response = await _repository.get(id);
  return response;
}

// Avoid
fetchPolicy(id) async {
  final response = await _repository.get(id);
  return response;
}
```

#### Null Safety

- Use nullable types (`?`) only when necessary
- Use null-aware operators: `?.`, `??`, `??=`
- Prefer early returns for null checks
- Use `late` keyword sparingly and only when initialization is guaranteed

```dart
// Good
final name = user?.name ?? 'Unknown';
if (user == null) return;

// Avoid
if (user != null) {
  final name = user!.name;
}
```

#### Error Handling

- Use custom exceptions for domain-specific errors
- Handle errors at the appropriate layer (presentation shows, domain transforms, data logs)
- Never swallow exceptions silently - at minimum, log them
- Use `Result` type patterns or `Either` for operations that can fail

```dart
// Good
class PolicyException implements Exception {
  final String message;
  final String? code;
  
  const PolicyException(this.message, {this.code});
  
  @override
  String toString() => 'PolicyException: $message${code != null ? ' ($code)' : ''}';
}

// In repository
try {
  final response = await api.getPolicy(id);
  return response;
} on SocketException {
  throw PolicyException('Network error', code: 'NETWORK_ERROR');
}
```

### State Management

- Use BLoC pattern with `flutter_bloc` as specified in project requirements
- Separate events, states, and bloc logic
- Use `Equatable` for state comparison
- Keep business logic out of UI widgets

```dart
// Events
abstract class PolicyEvent extends Equatable {
  const PolicyEvent();
}

class LoadPolicy extends PolicyEvent {
  final String id;
  const LoadPolicy(this.id);
}

// State
class PolicyState extends Equatable {
  final PolicyStatus status;
  final Policy? policy;
  final String? error;
  
  const PolicyState({
    this.status = PolicyStatus.initial,
    this.policy,
    this.error,
  });
}

// Bloc
class PolicyBloc extends Bloc<PolicyEvent, PolicyState> {
  final PolicyRepository repository;
  
  PolicyBloc({required this.repository}) : super(const PolicyState()) {
    on<LoadPolicy>(_onLoadPolicy);
  }
}
```

### Widget Guidelines

- Build reusable widgets in `presentation/widgets/`
- Use composition over inheritance
- Extract widget parameters into a `WidgetNameParams` class for complex widgets
- Use `const` constructors for stateless widgets
- Follow Flutter's widget lifecycle properly

### Testing Guidelines

- Unit tests in `test/unit/`
- Widget tests in `test/widget/`
- Integration tests in `test/integration/`
- Test file naming: `filename_test.dart`
- Use `group()` for grouping related tests
- Use `setUp()` and `tearDown()` for test fixtures

```dart
group('PolicyRepository', () {
  late PolicyRepository repository;
  late MockApiClient mockClient;
  
  setUp(() {
    mockClient = MockApiClient();
    repository = PolicyRepository(client: mockClient);
  });
  
  test('should return policy when API call succeeds', () async {
    // Arrange
    when(() => mockClient.get('/policy/1'))
        .thenAnswer((_) async => PolicyModel(...));
    
    // Act
    final result = await repository.getPolicy('1');
    
    // Assert
    expect(result.id, equals('1'));
  });
});
```

### Git and Commit Guidelines

- Run `flutter format .` and `flutter analyze` before committing
- Use conventional commit messages: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`
- Keep commits atomic and focused

### Localization (i18n)

- Default locale: `en_US`
- Secondary locale: `id_ID`
- Use `flutter_localizations` for translations
- Store ARB files in `lib/l10n/`
- Use semantic strings, avoid hardcoded text in UI

#### Localization Implementation Guidelines

For every new feature, you MUST apply multilingual support:

1. **Add translation keys to ARB files first**
   - Edit `lib/l10n/app_en.arb` (English - template)
   - Edit `lib/l10n/app_id.arb` (Indonesian)
   - Use semantic keys (e.g., `policyDetails`, `submitClaim`)

2. **Regenerate localization files**
   ```bash
   flutter gen-l10n
   ```

3. **Use localization in widgets/pages**
   ```dart
   final l10n = AppLocalizations.of(context)!;
   Text(l10n.policyDetails);
   ```

4. **Required imports**
   ```dart
   import 'package:my_customer/l10n/generated/app_localizations.dart';
   ```

5. **String interpolation rules**
   - DO: `'${l10n.welcome} $name'`
   - DO: `l10n.policyStatusActive(status)`
   - Avoid concatenating with raw strings

6. **Never hardcode display text** - Always use `l10n.keyName`

7. **Date/Number formatting** - Use `intl` package with locale-aware formatters
