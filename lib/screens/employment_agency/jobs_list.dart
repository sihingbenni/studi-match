import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/models/employment_agency/query_parameters.dart';
import 'package:studi_match/providers/employment_agency/job_provider.dart';

import '../../models/job.dart';

class EAJobsListScreen extends StatefulWidget {
  const EAJobsListScreen({Key? key}) : super(key: key);

  @override
  State<EAJobsListScreen> createState() => _EAJobsListState();
}

class _EAJobsListState extends State<EAJobsListScreen> {
  late final EAJobProvider jobProvider;
  final queryParameters = QueryParameters();

  final controller = AppinioSwiperController();

  int page = 1;
  List<Job> jobs = [];
  int maxNrOfResults = 0;
  int lastFetchedAt = 0;

  @override
  void initState() {
    super.initState();
    jobProvider = EAJobProvider(queryParameters);

    jobProvider.addListener(() {
      // on change update the list of jobs
      setState(() {
        jobs = jobProvider.jobs;
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
          title: const Text('Employment Agency Jobs List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            jobProvider.refresh();
          },
          child: const Icon(Icons.refresh),
        ),
        body: SizedBox(
          child: AppinioSwiper(
              controller: controller,
              backgroundCardsCount: 3,
              cardsCount: jobs.length,
              cardsSpacing: 10,
              onSwipe: (index, direction) {
                jobProvider.notify(index);
              },
              cardsBuilder: (context, index) {
                // set the job at the index
                final job = jobs[index];

                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: const DecorationImage(
                          image: NetworkImage('https://placekitten.com/500/1000'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black87],
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FutureBuilder(
                                future: job.logo,
                                builder: (context, logoSnapshot) {
                                  if (logoSnapshot.hasData) {
                                    return Wrap(
                                      children: [
                                        Image(
                                          image: logoSnapshot.data as ImageProvider,
                                          gaplessPlayback: true,
                                          width: 100,
                                          height: 100,
                                        )
                                      ],
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                            Text(job.title ?? 'no title',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Text(job.employer ?? 'no-employer',
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
        ),
      );
}
