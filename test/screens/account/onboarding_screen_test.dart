import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studi_match/screens/account/onboarding_screen.dart';
import 'package:studi_match/widgets/form/preference_form.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('OnBoardingScreen widget renders correctly', (WidgetTester tester) async {
    // Create a mock FirebaseAuth instance
    final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();

    // Replace the FirebaseAuth.instance with the mock instance
    await tester.pumpWidget(
      const MaterialApp(
        home: OnBoardingScreen(),
      ),
    );

    // Mock a logged-in user (customize as needed)
    final MockUser user = MockUser(
      isAnonymous: false,
      uid: 'test_user_uid',
      email: 'test@example.com',
    );

    // Mock the current user in FirebaseAuth
    mockFirebaseAuth.mockUser = user;

    // Provide the mock instance to the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: OnBoardingScreen(),
      ),
    );

    // Verify that the widget displays the app bar and the preference form.
    expect(find.text('Wähle deine Sucheinstellungen'), findsOneWidget);
    expect(find.text('Bevor du loslegen kannst, musst du noch ein paar Einstellungen vornehmen.'), findsOneWidget);
    expect(find.byType(PreferenceForm), findsOneWidget);
  });
}
