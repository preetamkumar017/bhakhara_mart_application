import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/modules/legal/view/privacy_policy_view.dart';
import 'package:bhakharamart/modules/legal/view/terms_conditions_view.dart';
import 'package:bhakharamart/res/routes/routes_name.dart';
import 'package:bhakharamart/core/themes/app_theme.dart';

void main() {
  group('Legal Pages Tests', () {
    testWidgets('Privacy Policy View renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.lightTheme,
          home: const PrivacyPolicyView(),
        ),
      );

      // Verify AppBar title
      expect(find.text('Privacy Policy'), findsWidgets);
      
      // Verify key sections exist
      expect(find.textContaining('Information We Collect'), findsOneWidget);
      expect(find.textContaining('Data Storage and Security'), findsOneWidget);
      expect(find.textContaining('Indian IT Act'), findsOneWidget);
      expect(find.textContaining('User Consent'), findsOneWidget);
      
      // Verify scrollable
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      
      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Terms & Conditions View renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.lightTheme,
          home: const TermsConditionsView(),
        ),
      );

      // Verify AppBar title
      expect(find.text('Terms & Conditions'), findsWidgets);
      
      // Verify key sections exist
      expect(find.textContaining('Order and Payment'), findsOneWidget);
      expect(find.textContaining('Cash on Delivery'), findsOneWidget);
      expect(find.text('2. Delivery'), findsOneWidget);
      expect(find.text('3. Cancellation Policy'), findsOneWidget);
      expect(find.textContaining('Refund and Replacement'), findsOneWidget);
      expect(find.textContaining('Product Quality and Responsibility'), findsOneWidget);
      
      // Verify scrollable
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      
      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Privacy Policy View has back button', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyView()),
                ),
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      // Verify back button exists
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('Terms & Conditions View has back button', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsConditionsView()),
                ),
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      // Verify back button exists
      expect(find.byType(BackButton), findsOneWidget);
    });

    test('Route names are correctly defined', () {
      expect(RoutesName.privacyPolicy, equals('/privacy-policy'));
      expect(RoutesName.termsConditions, equals('/terms-conditions'));
    });
  });
}
