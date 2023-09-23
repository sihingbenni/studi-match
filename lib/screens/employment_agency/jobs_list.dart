import 'package:flutter/material.dart';
import 'package:studi_match/models/employment_agency/query_parameters.dart';
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Employment Agency Jobs List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchJobs,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            // set the job at the index
            final job = jobs[index];

            // logger.i(index);
            // fetch more jobs if the index is a multiple of 25
            // do not fetch for the same index again
            // currently bugged, because the index is not the same as the length of the list
            // for every 25 jobs 50 new are fetched => quadratic growth.
            if (index != lastFetchedAt && index % 25 == 0) {
              lastFetchedAt = index;
              page = (index / 25 + 1).floor();
              fetchJobs();
            }

            if (index == jobs.length - 1) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.green,
              ));
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
    queryParameters.page = page;

    final response = await EmploymentAgencyApi.callJobsApi(queryParameters);
    setState(() {
      jobs.addAll(response.jobListings);
      maxNrOfResults = response.maxNrOfResults;
    });
    logger.d('fetching Jobs finished');
  }
}
