import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/models/employment_agency/query_parameters.dart';
import 'package:studi_match/providers/employment_agency/job_provider.dart';

import '../../models/job.dart';
import '../../utilities/logger.dart';

class EAJobsListScreen extends StatefulWidget {
  const EAJobsListScreen({Key? key}) : super(key: key);

  @override
  State<EAJobsListScreen> createState() => _EAJobsListState();
}

class _EAJobsListState extends State<EAJobsListScreen> {
  int page = 1;

  final queryParameters = QueryParameters();

  @override
  void initState() {
    super.initState();

    fetchJobs();
  }

  List<Job> jobs = [];
  int maxNrOfResults = 0;
  int lastFetchedAt = 0;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: const Text('Employment Agency Jobs List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchJobs,
          child: const Icon(Icons.add),
        ),
        body: SizedBox(
          child: AppinioSwiper(
              cardsCount: jobs.length,
              cardsBuilder: (context, index) {
                // set the job at the index
                final job = jobs[index];

                // logger.i(index);
                // fetch more jobs if the index is a multiple of 25
                return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://placekitten.com/500/1000'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child:  Container(
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
                              Text(job.title ?? 'no title', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              Text(job.employer ?? 'no-employer', style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      )
                    ],
                );
              }
          ),
        ),
  );

  void fetchJobs() async {
    queryParameters.page = page;
    final jobProvider = EAJobProvider();
    await jobProvider.getJobs(queryParameters);
    setState(() {
      jobs.addAll(jobProvider.jobs);
    });
  }
}
