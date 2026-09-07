import 'package:flutter/material.dart';
import 'package:studi_match/models/address.dart';
import 'package:studi_match/models/job_details.dart';
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
  Widget logo = const Icon(Icons.apartment, size: 60);
  Widget map = const Icon(Icons.map, size: 60);

  late JobDetails? jobDetails;

  Job.fromEAJson(Map<String, dynamic> json) {
    jobDetails = null;
    profession = (json['hauptberuf'] ?? json['beruf'])?.toString();
    title = (json['stellenangebotsTitel'] ?? json['titel'])?.toString();
    referenceNr = (json['referenznummer'] ?? json['refnr'])?.toString();

    dynamic locationData;
    if (json['stellenlokationen'] != null &&
        (json['stellenlokationen'] is List) &&
        (json['stellenlokationen'] as List).isNotEmpty) {
      locationData = json['stellenlokationen'][0];
    } else {
      locationData = json['arbeitsort'];
    }
    address = Address.fromEAJson(locationData, json['entfernung']);

    employer = (json['firma'] ?? json['arbeitgeber'])?.toString();

    final pubDateStr = json['aktuelleVeroeffentlichungsdatum'] ??
        json['datumErsteVeroeffentlichung'] ??
        json['veroeffentlichungszeitraum']?['von'];
    currentPublicationDate =
        pubDateStr != null ? DateTime.tryParse(pubDateStr.toString()) : null;

    final modDateStr =
        json['modifikationsTimestamp'] ?? json['aenderungsdatum'];
    modificationTimestamp =
        modDateStr != null ? DateTime.tryParse(modDateStr.toString()) : null;

    final entryDateStr = json['eintrittsdatum'] ??
        json['eintrittszeitraum']?['von'];
    entryDate =
        entryDateStr != null ? DateTime.tryParse(entryDateStr.toString()) : null;

    logoHashId = (json['arbeitgeberKundennummerHash'] ??
            json['kundennummerHash'] ??
            json['logoHashId'])
        ?.toString();
    hashId = (json['referenznummer'] ??
            json['refnr'] ??
            json['hashId'] ??
            '')
        .toString();

    JobLogoProvider.getLogo(logoHashId).then(
      (value) => logo = value,
    );
    JobMapProvider.getMap(address).then(
      (value) => map = value,
    );
  }

  Job.fromJobDetails(JobDetails this.jobDetails) {
    if (jobDetails == null) {
      throw Exception('JobDetails must not be null');
    }
    profession = jobDetails!.profession;
    title = jobDetails!.title;
    referenceNr = jobDetails!.referenceNr;
    address = jobDetails!.workplaces.isNotEmpty
        ? jobDetails!.workplaces.first
        : null;
    employer = jobDetails!.employer;
    currentPublicationDate = jobDetails!.currentPublicationDate;
    modificationTimestamp = jobDetails!.modificationTimestamp;
    entryDate = jobDetails!.entryDate;
    logoHashId = jobDetails!.employerLogoHashId;
    hashId = jobDetails!.hashId;
    JobLogoProvider.getLogo(logoHashId).then(
      (value) => logo = value,
    );
    JobMapProvider.getMap(address).then(
      (value) => map = value,
    );
  }
}
