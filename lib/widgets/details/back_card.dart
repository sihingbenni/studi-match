import 'package:flutter/material.dart';
import 'package:studi_match/models/job.dart';
import 'package:studi_match/models/job_details.dart';

class BackCard extends StatelessWidget {
  const BackCard({super.key, required this.job, required this.accentColor});

  final Job job;
  final Color accentColor;

  @override
  Widget build(BuildContext context) => Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: accentColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(builder: (context) {
            if (job.jobDetails == null) {
              return const CircularProgressIndicator();
            } else {
              JobDetails jobDetails = job.jobDetails!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jobDetails.title ?? 'no title',
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          jobDetails.profession ?? 'no profession',
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
                        job.logo,
                        Text(
                          jobDetails.employer ?? 'no employer',
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 16),
                        ),
                        Text(
                          '${job.address?.city ?? 'no-city'}, ${job.address?.country ?? 'no-country'}',
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
