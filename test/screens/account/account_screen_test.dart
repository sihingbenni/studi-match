import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studi_match/providers/firebase_auth_provider.dart';
import 'package:studi_match/providers/job_preferences_provider.dart';
import 'package:studi_match/screens/account/account_screen.dart';
import 'package:studi_match/widgets/accounts/anonymous_account.dart';
import 'package:studi_match/widgets/accounts/logged_in_account.dart';
import 'package:studi_match/widgets/appbar/custom_appbar.dart';

import '../../mocks/job_preferences_provider_mock.dart';

void main() {
  // Create a mock FirebaseAuth instance
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();

  setUpAll(() {
    FirebaseAuthProvider.overwriteAuthInstance(mockFirebaseAuth);

    JobPreferencesProvider.instance = JobPreferencesProviderMock();
  });

  /// call this method first to make sure that no user is logged in
  testWidgets('Account Screen not logged in renders correctly', (WidgetTester tester) async {

    // assert that no user is currently logged in
    assert(mockFirebaseAuth.currentUser == null);

    await tester.pumpWidget(
      const MaterialApp(
        home: AccountScreen(),
      ),
    );

    expect(find.byType(CustomAppbar), findsOneWidget);
    // expect AlertDialog, that tells the user to log in
    expect(find.byType(AlertDialog), findsOneWidget);

    final messageFinder = find.text('Du bist leider nicht eingeloggt.');
    // verify that the AlertDialog is displayed with the correct message
    expect(messageFinder, findsOneWidget);

  });

  testWidgets('Account Screen when anonymously logged in renders correctly',
      (WidgetTester tester) async {

    mockFirebaseAuth.signInAnonymously();

    assert(mockFirebaseAuth.currentUser != null);
    assert(mockFirebaseAuth.currentUser!.isAnonymous);

    await tester.pumpWidget(
      const MaterialApp(
        home: AccountScreen(),
      ),
    );

    expect(find.byType(AnonymousAccount), findsOneWidget);

    expect(find.byType(CustomAppbar), findsOneWidget);
  });

  testWidgets('Account Screen logged in renders correctly', (WidgetTester tester) async {

    mockFirebaseAuth.signInWithEmailAndPassword(email: 'max.mustermann@example.com', password: 'secret');

    // assert that the login worked
    assert(mockFirebaseAuth.currentUser != null);

    await tester.pumpWidget(
      const MaterialApp(
        home: AccountScreen(),
      ),
    );

    expect(find.byType(CustomAppbar), findsOneWidget);
    // expect loading indicator waiting for login data from snapshot
    expect(find.byType(LoggedInAccount), findsOneWidget);
  });
}
