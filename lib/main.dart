import 'package:flutter/material.dart';
import 'package:studi_match/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // runApp(const MyDemoApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StudiMatchApp());
}

class StudiMatchApp extends StatelessWidget {
  const StudiMatchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'StudiMatch',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),

        home: const Home() // which widget will be displayed on the home screen
      );
}
