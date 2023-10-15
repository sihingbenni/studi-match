import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/models/query_parameters.dart';
import 'package:studi_match/providers/job_provider.dart';
import 'package:studi_match/screens/account/account.dart';
import 'package:studi_match/screens/authentication/authentication_page.dart';
import 'package:studi_match/utilities/logger.dart';

import '../../models/job.dart';
import '../../widgets/navigation/bottom_navigation_bar.dart';

class EAJobsListScreen extends StatefulWidget {
  const EAJobsListScreen({Key? key}) : super(key: key);

  @override
  State<EAJobsListScreen> createState() => _EAJobsListState();
}

class _EAJobsListState extends State<EAJobsListScreen> {
  late final JobProvider jobProvider;
  final queryParameters = QueryParameters();

  int _currentIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final controller = AppinioSwiperController();

  int page = 1;
  List<Job> jobList = [];
  int maxNrOfResults = 0;
  int lastFetchedAt = 0;

  @override
  void initState() {
    super.initState();
    jobProvider = JobProvider();

    jobProvider.addListener(() {
      // on change update the list of jobs
      setState(() {
        jobList = jobProvider.jobList.values.toList();
      });
    });
  }

  @override
  void dispose() {
    jobProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.data?.isAnonymous ?? true) {
                return IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AuthenticationPage(),
                        ),
                      );
                    }, icon: const Icon(Icons.login));
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  // User is logged in
                  return FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccountPage(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(2.0),
                      backgroundColor: Colors.transparent,
                    ),
                    child: snapshot.data?.photoURL != null
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data!.photoURL!),
                          )
                        : const Icon(Icons.person),
                  );
                } else {
                  // User is not logged in
                  return IconButton(
                    icon: const Icon(Icons.login),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AuthenticationPage(),
                        ),
                      );
                    },
                  );
                }
              } else {
                // Return a loading indicator while the authentication state is loading
                return const CircularProgressIndicator();
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EAJobsListScreen(),
                ));
          },
          child: const Icon(Icons.refresh),
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _currentIndex,
          onItemTapped: _onItemTapped,
        ),
        body: SizedBox(
          child: AppinioSwiper(
              controller: controller,
              backgroundCardsCount: 3,
              cardsCount: jobList.length,
              cardsSpacing: 10,
              onSwipe: (index, direction) {
                jobProvider.notify(
                    newIndex: index,
                    removedJob: jobList[index - 1],
                    keywords: jobList[index - 1].foundByKeyword.toList());
              },
              onEnd: () {
                logger.w('End reached');
                //TODO make sure that no more are loading
              },
              cardsBuilder: (context, index) {
                // set the job at the index
                final Job job = jobList[index];

                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.primaries[index % Colors.primaries.length],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                     Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            job.logo,
                            Text(job.title ?? 'no title',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Text(job.employer ?? 'no-employer',
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                  ],
                );
              }),
        ),
      );
}
