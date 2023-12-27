import 'package:flutter/material.dart';
import 'package:studi_match/providers/firebase_auth_provider.dart';
import 'package:studi_match/services/firebase/user_service.dart';
import 'package:studi_match/widgets/form/preference_form.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final String uuid = FirebaseAuthProvider.authInstance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    UserService().addUser(uuid);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Wähle deine Sucheinstellungen')),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
                'Bevor du loslegen kannst, musst du noch ein paar Einstellungen vornehmen.'),
            PreferenceForm(uuid: uuid),
          ],
        ),
      );
}
