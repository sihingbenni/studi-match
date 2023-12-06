import 'package:flutter/material.dart';
import 'package:studi_match/models/job_details.dart';
import 'package:studi_match/models/workplace.dart';
import 'package:studi_match/providers/job_logo_provider.dart';
import 'package:studi_match/providers/job_map_provider.dart';

/// Model of the Arbeitsagentur Job
class Job {
  /// List of keywords that were used to find this job
  Set<String> foundByKeyword = {};

  late final String? profession;
  late final String? title;
  late final String? referenceNr;
  late final Address? address;
  late final String? employer;
  late final DateTime? currentPublicationDate;
  late final DateTime? modificationTimestamp;
  late final DateTime? entryDate;
  late final String? logoHashId;
  late final String hashId;
  late final StatelessWidget logo;
  late final StatelessWidget map;

  late JobDetails? jobDetails;

  Job.fromEAJson(Map<String, dynamic> json) {
    jobDetails = null;
    profession = json['beruf'];
    title = json['titel'];
    referenceNr = json['refnr'];
    address = Address.fromEAJson(json['arbeitsort']);
    employer = json['arbeitgeber'];
    currentPublicationDate = DateTime.parse(json['aktuelleVeroeffentlichungsdatum']);
    modificationTimestamp = DateTime.parse(json['modifikationsTimestamp']);
    entryDate = DateTime.parse(json['eintrittsdatum']);
    logoHashId = json['logoHashId'];
    hashId = json['hashId'];
    JobLogoProvider.getLogo(logoHashId).then(
      (value) => logo = value,
    );
    JobMapProvider.getMap(address?.coordinates).then(
      (value) => map = value,
    );
  }
}
