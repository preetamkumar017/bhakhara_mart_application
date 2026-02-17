import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/res/routes/routes_name.dart';
import 'package:bhakharamart/res/routes/routes.dart';
import 'package:bhakharamart/core/themes/app_theme.dart';

void main() {
  group('Profile to Legal Pages Integration Tests', () {
    testWidgets('Navigate from Profile to Privacy Policy', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.lightTheme,
          initialRoute: RoutesName.profile,
          getPages: AppRoutes.appRoutes(),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap Privacy Policy option
      final privacyPolicyTile = find.text('Privacy Policy');
      expect(privacyPolicyTile, findsOneWidget);

      await tester.tap(privacyPolicyTile);
      await tester.pumpAndSettle();

      // Verify Privacy Policy page is displayed
      expect(find.text('Privacy Policy'), findsWidgets);
      expect(find.textContaining('Information We Collect'), findsOneWidget);
    });

    testWidgets('Navigate from Profile to Terms & Conditions', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.lightTheme,
          initialRoute: RoutesName.profile,
          getPages: AppRoutes.appRoutes(),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap Terms & Conditions option
      final termsTile = find.text('Terms & Conditions');
      expect(termsTile, findsOneWidget);

      await tester.tap(termsTile);
      await tester.pumpAndSettle();

      // Verify Terms & Conditions page is displayed
      expect(find.text('Terms & Conditions'), findsWidgets);
      expect(find.textContaining('Order and Payment'), findsOneWidget);
    });

    testWidgets('Navigate back from Privacy Policy to Profile', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.lightTheme,
          initialRoute: RoutesName.profile,
          getPages: AppRoutes.appRoutes(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to Privacy Policy
      await tester.tap(find.text('Privacy Policy'));
      await tester.pumpAndSettle();

      // Verify we're on Privacy Policy page
      expect(find.textContaining('Information We Collect'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify we're back on Profile page
      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('Navigate back from Terms & Conditions to Profile', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.lightTheme,
          initialRoute: RoutesName.profile,
          getPages: AppRoutes.appRoutes(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to Terms & Conditions
      await tester.tap(find.text('Terms & Conditions'));
      await tester.pumpAndSettle();

      // Verify we're on Terms & Conditions page
      expect(find.textContaining('Order and Payment'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify we're back on Profile page
      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('Terms & Conditions'), findsOneWidget);
    });

    testWidgets('Profile page has correct icons for legal pages', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.lightTheme,
          initialRoute: RoutesName.profile,
          getPages: AppRoutes.appRoutes(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Privacy Policy icon
      expect(find.byIcon(Icons.privacy_tip_outlined), findsOneWidget);

      // Verify Terms & Conditions icon
      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
    });
  });
}
