// This is a basic Flutter widget test for the Insurance Customer Portal.
//
// It verifies that the app renders the splash screen correctly
// with the expected UI elements.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_customer/core/constants/app_constants.dart';
import 'package:my_customer/data/datasources/api_client.dart';
import 'package:my_customer/data/repositories/auth_repository.dart';
import 'package:my_customer/main.dart';

void main() {
  late AuthRepository authRepository;

  setUp(() {
    // Set up mock SharedPreferences to prevent platform channel errors
    SharedPreferences.setMockInitialValues({});

    // Set base URL to bypass dotenv dependency in tests
    ApiEndpoints.baseUrl = 'https://test.api.example.com/v1';

    // Create real instances for the smoke test
    final apiClient = ApiClient();
    authRepository = AuthRepository(apiClient: apiClient);
  });

  testWidgets('App renders splash screen with expected elements',
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp(authRepository: authRepository));

    // Verify the splash screen displays the shield icon
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

    // Verify the loading indicator is present
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump through the splash screen's 2-second delay to dispose cleanly
    await tester.pumpAndSettle();
  });
}
