import 'package:flutter/material.dart';
import 'package:studi_match/widgets/Dialog/auth_dialog.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1545315003-c5ad6226c272'),
              fit: BoxFit.cover,
            )),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_home_work_outlined,
                    color: Colors.white,
                    size: 80,
                  ),
                  Text(
                    'Studi Match',
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
          const Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Match dein nächstes Abenteuer.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    AuthenticationDialog(),
                    Text(
                      'und finde dein neues Team hier!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ))
        ]),
      );

}


