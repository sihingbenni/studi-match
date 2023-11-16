import 'package:flutter/material.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/models/job_details.dart';
import 'package:studi_match/providers/job_details_provider.dart';

class BackCard extends StatefulWidget {
  const BackCard({super.key, required this.job, required this.accentColor});

  final Job job;
  final Color accentColor;

  @override
  State<BackCard> createState() => _BackCardState();
}

class _BackCardState extends State<BackCard> {
  final JobDetailsProvider jobDetailsProvider = JobDetailsProvider();

  JobDetails? _jobDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobDetailsProvider.addListener(() {
      // on change update the jobDetails
      setState(() {
        _jobDetails = jobDetailsProvider.jobDetails!;
      });
    });
    jobDetailsProvider.getDetails(widget.job.hashId);
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.accentColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(builder: (context) {
            if (_jobDetails == null) {
              return const CircularProgressIndicator();
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _jobDetails!.title ?? 'no title',
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.job.profession ?? 'no profession',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Kontakt',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        widget.job.logo,
                        Text(
                          widget.job.employer ?? 'no employer',
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 16),
                        ),
                        Text(
                          '${widget.job.address?.city ?? 'no-city'}, ${widget.job.address?.country ?? 'no-country'}',
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Beschreibung',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          }),
        ),
      ]
  );
}
