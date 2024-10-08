import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studi_match/providers/google_sign_in.dart';
import 'package:studi_match/screens/home/home_screen.dart';
import 'package:studi_match/utilities/snack_bar.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StudiMatchApp());
}

class StudiMatchApp extends StatelessWidget {
  const StudiMatchApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
            scaffoldMessengerKey: SnackBarUtil.messengerKey,
            debugShowCheckedModeBanner: false,
            title: 'StudiMatch',
            theme: ThemeData(
              primarySwatch: Colors.green,
              useMaterial3: true,
            ),
            home:
                const HomeScreen() // which widget will be displayed on the home screen
            ),
      );
}
