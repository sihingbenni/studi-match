import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/screens/authentication/authentication_screen.dart';
import 'package:studi_match/screens/employment_agency/jobs_list_screen.dart';

import '../../widgets/router/nav_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const EAJobsListScreen();
        } else {
          return Scaffold(
            body: Stack(children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1545315003-c5ad6226c272'),
                    colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_fire_department_outlined,
                        color: Colors.white,
                        size: 80,
                      ),
                      Text(
                        'StudiMatch',
                        style: TextStyle(
                            fontSize: 36,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Match dein nächstes Abenteuer.',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () => {
                                    Navigator.of(context).pop(),
                                    Navigator.of(context).push(
                                      NavRouter(
                                        builder: (context) =>
                                            const AuthenticationScreen(),
                                      ),
                                    )
                                  },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                'Jetzt durchstarten 🚀',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                          const Text(
                            'und finde dein neues Team hier!',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ))
            ]),
          );
        }
      });
}
