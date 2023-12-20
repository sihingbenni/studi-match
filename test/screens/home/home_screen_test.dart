import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studi_match/providers/firebase_auth_provider.dart';
import 'package:studi_match/screens/authentication/authentication_screen.dart';
import 'package:studi_match/screens/home/home_screen.dart';

void main() {

  // Create a mock FirebaseAuth instance
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();

  setUpAll(() {
    FirebaseAuthProvider.overwriteAuthInstance(mockFirebaseAuth);
  });


  testWidgets('HomeScreen widget renders correctly when no user is logged in', (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Verify that the widget displays the StudiMatch logo and the authentication button.
    expect(find.text('StudiMatch'), findsOneWidget);
    expect(find.text('Match dein nächstes Abenteuer.'), findsOneWidget);
    expect(find.text('Jetzt durchstarten 🚀'), findsOneWidget);
    expect(find.text('und finde dein neues Team hier!'), findsOneWidget);

    // Tap the authentication button and verify that it navigates to the AuthenticationScreen.
    await tester.tap(find.text('Jetzt durchstarten 🚀'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthenticationScreen), findsOneWidget);
  });
}
