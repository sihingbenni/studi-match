import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/providers/employment_agency/api.dart';

import '../../models/job.dart';
import '../../utilities/logger.dart';

class EAJobsListScreen extends StatefulWidget {
  const EAJobsListScreen({Key? key}) : super(key: key);

  @override
  State<EAJobsListScreen> createState() => _EAJobsListState();
}

class _EAJobsListState extends State<EAJobsListScreen> {
  int page = 1;

  Map<String, String> queryParameters = {
    // 'was': 'Studentische Aushilfe, Werkstudent',
    // 'wo': '24114',
    //berufsfeld:Informatik,
    'page': '1',
    'size': '50',
    //arbeitgeber:Deutsche%2520Bahn%2520AG,
    //veroeffentlichtseit:30,
    //zeitarbeit:true,
    //angebotsart:1,
    //befristung:1,
    //arbeitszeit:vz,
    //behinderung:true,
    //corona:true,
    'umkreis': '25'
  };

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
                                'https://images.unsplash.com/photo-1535957998253-26ae1ef29506?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1936&q=80'),
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
    queryParameters['page'] = page.toString();

    final response = await EmploymentAgencyApi.callJobsApi(queryParameters);
    setState(() {
      jobs.addAll(response.jobListings);
      maxNrOfResults = response.maxNrOfResults;
    });
    logger.d('fetching Jobs finished');
  }
}
