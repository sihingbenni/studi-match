import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/models/query_parameters.dart';
import 'package:studi_match/providers/job_provider.dart';

import '../../models/job.dart';

class EAJobsListScreen extends StatefulWidget {
  const EAJobsListScreen({Key? key}) : super(key: key);

  @override
  State<EAJobsListScreen> createState() => _EAJobsListState();
}

class _EAJobsListState extends State<EAJobsListScreen> {
  late final JobProvider jobProvider;
  final queryParameters = QueryParameters();

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
          title: const Text('Employment Agency Jobs List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            jobProvider.refresh();
            widget.createState();
          },
          child: const Icon(Icons.refresh),
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
              cardsBuilder: (context, index) {
                // set the job at the index
                final Job job = jobList[index];

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
                                future: null,
                                // future: JobLogoProvider.getLogo(job.logoHashId),
                                builder: (context, logoSnapshot) {
                                  if (logoSnapshot.hasData) {
                                    return Wrap(
                                      children: [logoSnapshot.data as CachedNetworkImage],
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
