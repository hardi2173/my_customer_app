# Insurance Customer Portal (Flutter)

A multi-platform mobile application designed for insurance customers to manage policies, track claims, and generate product illustrations. This application is built with a focus on high security, responsiveness, and bilingual accessibility.

## 1. Project Specifications
- Framework: Flutter (Latest Stable)
- Target Platforms: 
    - ***Android***: API Level 30+ (Android 11)
    - ***iOS***: SDK 18.0+
- Default Language: English (EN)
- Secondary Language: Bahasa Indonesia (ID)

## 2. Core Architecture & Features
***Business Logic Features***
- ***Authentication***: Secure login with multi-factor support and session management.
- ***Policy Management***: 
    - ***Policy Tracker***: Real-time status of active, lapsed, or pending policies.
- ***Account Management***: Profile updates and document storage.
- ***Transaction Flow***:
    - ***Create Illustration***: Calculate premiums based on customer profiles.
    - ***Submit Proposal***: Digital application submission (e-SPA).
- ***Claims Lifecycle***:
    - ***Submit Claim***: Document upload and digital form entry.
    - ***Claim Tracker***: Progress visualization from "Submitted" to "Paid."

***System Utilities***
- ***Dynamic Theming***: Centralized theme data allowing for easy brand color overrides and Dark/Light mode support.
- ***Localization (i18n)***: Implemented using flutter_localizations. Default locale is en_US.
- ***Responsive Layouts***: Utilization of LayoutBuilder or Sizer to ensure consistent UI across various handset and tablet dimensions.

## 3. Developer Getting Started
***Prerequisites***
- ***Flutter SDK***: Ensure the version matches the project's `pubspec.yaml`.
- ***Android Studio / VS Code***: With Flutter/Dart extensions.
- ***CocoaPods***: Required for iOS dependency management.

***Environment Setup***
- ***Clone the Repository***:
```bash
git clone [repository-url]
cd insurance-customer-app
```
- ***Install Dependencies***:
```bash
flutter pub get
```
- ***Configure Environment Variables***:
Create a `.env` file in the root directory to manage API endpoints and keys.
```bash
API_BASE_URL=https://api.insurance-core.com/v1
ENCRYPTION_KEY=your_secret_key
```
- ***Run the App:***
```bash
flutter run
```

## 4. Coding Standards
- ***State Management***: BLoC pattern using flutter_bloc
- ***Folder Structure***:
```plaintext
lib/
├── core/                    # Themes, constants, and configuration
│   ├── config/              # App configuration
│   ├── constants/          # App constants and API endpoints
│   └── theme/               # App themes (light/dark)
├── data/                    # Data layer
│   ├── datasources/         # API client
│   ├── models/              # Data models
│   └── repositories/        # Repository implementations
├── l10n/                    # Localization (ARB files)
├── presentation/             # UI layer
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

**Module Organization Guidelines:**
- Each feature/module should have its own folder under `bloc/` and `pages/`
- Use singular names for folders (e.g., `account/`, not `accounts/`)
- Screen files should be named with `_screen.dart` or `_page.dart` suffix
- BLoC files follow: `{name}_bloc.dart`, `{name}_event.dart`, `{name}_state.dart`

***Formatting***: Run flutter format . before every commit.