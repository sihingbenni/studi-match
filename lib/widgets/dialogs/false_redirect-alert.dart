import 'package:flutter/material.dart';

import '../../screens/account/account_screen.dart';
import '../router/nav_router.dart';

class FalseDirectAlert extends StatelessWidget {
  const FalseDirectAlert({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Du hast dich leider verlaufen.'),
        content: const Text(
          'Um diese Funktion nutzen zu können, klicke bitte auf "Weiter".',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                NavRouter(
                  builder: (context) => const AccountScreen(),
                ),
              );
            },
            child: const Text(
              'Weiter',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ],
      );
}
