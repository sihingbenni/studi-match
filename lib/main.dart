import 'package:flutter/material.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/screens/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load the config
  await ConfigProvider().loadConfig();

  // runApp(const MyDemoApp());
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
