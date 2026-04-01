# Production Build Guide

## Prerequisites

- Flutter SDK (latest stable)
- Android Studio / Xcode installed
- Java 17+
- Apple Developer account (for iOS)

---

## Android

### 1. Generate Keystore

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

You will be prompted for:
- Keystore password
- Key password
- Your name, organization, etc.

### 2. Configure Signing

Edit `android/key.properties`:

```properties
storePassword=<your-keystore-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=upload-keystore.jks
```

> **Do NOT commit** `key.properties` or `*.jks` files. They are in `.gitignore`.

### 3. Update Version

In `pubspec.yaml`:

```yaml
version: 1.0.0+1  # format: <version>+<buildNumber>
```

Increment `buildNumber` for each Play Store upload.

### 4. Build App Bundle

```bash
# Ensure dependencies are up to date
flutter pub get

# Run analysis and tests
flutter analyze
flutter test

# Build release AAB
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 5. Upload to Google Play

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app → **Release** → **Testing** → **Internal testing**
3. Upload `app-release.aab`
4. Fill in release notes
5. Submit for review

---

## iOS

### 1. Prerequisites

- macOS with Xcode installed
- Apple Developer Program membership ($99/year)
- App registered in [App Store Connect](https://appstoreconnect.apple.com)

### 2. Configure Signing

```bash
open ios/Runner.xcworkspace
```

In Xcode:
1. Select **Runner** in the project navigator
2. Go to **Signing & Capabilities**
3. Select your **Team** (Apple Developer account)
4. Ensure **Automatically manage signing** is checked

### 3. Set Minimum Deployment Target

In `ios/Podfile`:

```ruby
platform :ios, '13.0'
```

### 4. Update Version

Same as Android — update `pubspec.yaml` version field.

### 5. Build IPA

```bash
# Run analysis and tests
flutter analyze
flutter test

# Build release IPA
flutter build ipa --release
```

Output: `build/ios/ipa/*.ipa`

### 6. Upload to App Store

Option A — Xcode:
1. Open `ios/Runner.xcworkspace`
2. Product → Archive
3. Distribute App → App Store Connect → Upload

Option B — Transporter:
1. Download [Transporter](https://apps.apple.com/app/transporter/id1450874784) from Mac App Store
2. Drag and drop the `.ipa` file
3. Click Deliver

Option C — Command line:

```bash
xcrun altool --upload-app -f build/ios/ipa/*.ipa -t ios -u <apple-id> -p <app-specific-password>
```

---

## Environment Configuration

### Production `.env`

Create a production `.env` file:

```env
API_BASE_URL=https://api.production-domain.com/v1
```

Update `AppConfig.apiBaseUrl` in `lib/core/config/app_config.dart` if needed.

### Build-time environment

For different environments, you can use Dart defines:

```bash
flutter build appbundle --release --dart-define=ENV=production
```

---

## Checklist Before Release

- [ ] `flutter analyze` — no issues
- [ ] `flutter test` — all tests pass
- [ ] App version updated in `pubspec.yaml`
- [ ] Production `.env` configured
- [ ] App icon and splash screen finalized
- [ ] Android signing configured (`key.properties`)
- [ ] iOS signing configured (Xcode team selected)
- [ ] Privacy policy URL ready
- [ ] App screenshots prepared for store listings
- [ ] Content rating completed

---

## Quick Reference

| Task | Command |
|------|---------|
| Analyze | `flutter analyze` |
| Test | `flutter test` |
| Build Android AAB | `flutter build appbundle --release` |
| Build Android APK | `flutter build apk --release` |
| Build iOS IPA | `flutter build ipa --release` |
| Bump version | Edit `pubspec.yaml` version field |
| Clean build | `flutter clean && flutter pub get` |
