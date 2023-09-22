import 'package:studi_match/models/workplace.dart';

/// Model of the Arbeitsagentur Job
class Job {
  late final String? profession;
  late final String? title;
  late final String? referenceNr;
  late final Workplace? workplace;
  late final String? employer;
  late final DateTime? currentPublicationDate;
  late final DateTime? modificationTimestamp;
  late final DateTime? entryDate;
  late final String? logoHashId;
  late final String hashId;

  Job.fromEAJson(Map<String, dynamic> json) {
    profession = json['beruf'];
    title = json['titel'];
    referenceNr = json['refnr'];
    workplace = Workplace.fromEAJson(json['arbeitsort']);
    employer = json['arbeitgeber'];
    currentPublicationDate = DateTime.parse(json['aktuelleVeroeffentlichungsdatum']);
    modificationTimestamp = DateTime.parse(json['modifikationsTimestamp']);
    entryDate = DateTime.parse(json['eintrittsdatum']);
    logoHashId = json['logoHashId'];
    hashId = json['hashId'];
  }
}
