import 'package:flutter/material.dart';
import 'package:studi_match/screens/employment_agency/jobs_list_screen.dart';
import 'package:studi_match/widgets/dialog/filter_options.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Preferenzen Auswählen'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Wir wissen noch gar nicht wonach du suchst!'),
              const FilterChipWidget(),
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
      );
}