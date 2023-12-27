import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:studi_match/models/job.dart';

class FrontCard extends StatelessWidget {
  const FrontCard({super.key, required this.job, required this.accentColor});

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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [job.logo],
              ),
              const SizedBox(height: 8),
              Text(job.title ?? 'Kein Titel angegeben',
                  style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Text(job.employer ?? 'Kein Arbeitgeber angegeben',
                  style: const TextStyle(color: Colors.black87)),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    'Wann:',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                        '${job.entryDate?.day}.${job.entryDate!.month}.${job.entryDate!.year}',
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    'Wo:',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      '${job.address?.zipCode ?? ''} ${job.address?.city}, ${job.address?.country}',
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    'Was:',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      job.profession ?? 'Kein Beruf angegeben',
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    'Aktuelle Veröffentlichung:',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                        '${job.currentPublicationDate?.day}.${job.currentPublicationDate!.month}.${job.currentPublicationDate!.year}',
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 16)),
                  ),
                ],
              ),
              // MAP
              Flexible(
                fit: FlexFit.loose,
                child: InkWell(
                  onTap: () async {
                    if (job.address?.street != null) {
                      MapsLauncher.launchCoordinates(
                        job.address!.coordinates!.lat,
                        job.address!.coordinates!.lon,
                        job.employer,
                      );
                    } else {
                      MapsLauncher.launchQuery(
                        '${job.address?.zipCode} ${job.address?.city}, ${job.address?.country}',
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      // Adjust the radius as needed
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child:
                            job.map, // Replace job.map with your actual widget
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]);
}
