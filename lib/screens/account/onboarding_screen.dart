import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/screens/employment_agency/jobs_list_screen.dart';
import 'package:studi_match/services/firebase/user_service.dart';
import 'package:studi_match/widgets/form/preference_form.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  final String uuid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    UserService().addUser(uuid);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Auswahl deiner Preferencen')),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Center(
              child: Column(
                children: [
                  const Text('Wir wissen noch gar nicht wonach du suchst!'),
                  PreferenceForm(uuid: uuid),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(NavRouter(
                        builder: (context) => const EAJobsListScreen(),
                      ));
                    },
                    child: const Text('Weiter'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}