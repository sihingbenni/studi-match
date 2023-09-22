
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Employment Agency Jobs List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchJobs,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: maxNrOfResults,
          itemBuilder: (context, index) {
            // set the job at the index
            final job = jobs[index];

            // logger.i(index);
            // fetch more jobs if the index is a multiple of 25
            if (index != lastFetchedAt && index % 25 == 0) {
              lastFetchedAt = index;
              page = (index / 25 + 1).floor();
              fetchJobs();
            }

            return ListTile(
              title: Text(job.title ?? 'no-title'),
              subtitle: Text(job.employer ?? 'no-employer'),
            );
          },
          addAutomaticKeepAlives: true,
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
