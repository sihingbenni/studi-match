import 'package:flutter/material.dart';
import 'package:studi_match/providers/firebase_auth_provider.dart';
import 'package:studi_match/widgets/dialogs/false_redirect_alert.dart';

import '../form/preference_form.dart';

class AnonymousAccount extends StatelessWidget {
  final String uuid;

  const AnonymousAccount({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuthProvider.authInstance.currentUser!.isAnonymous) {
     return Padding(
       padding: const EdgeInsets.all(16.0),
       child: ListView(
         children: [
           Column(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             mainAxisSize: MainAxisSize.max,
             children: [
               const Text('Hallo 👋',
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
               const Text(
                   'Du bist anonym unterwegs. Wenn du die volle Kraft '
                       'unserer App austesten möchtest, dann musst du '
                       'dich anmelden!',
                   textAlign: TextAlign.center,
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
               const SizedBox(height: 20),
               PreferenceForm(uuid: uuid),
             ],
           ),
         ],
       ),
     );
    } else {
      return const FalseDirectAlert();
    }
  }
}
