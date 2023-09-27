import 'package:studi_match/models/workplace.dart';

/// Model of the Arbeitsagentur Job
class Job {
  String? profession;
  String? title;
  String? referenceNr;
  Workplace? workplace;
  String? employer;
  DateTime? currentPublicationDate;
  DateTime? modificationTimestamp;
  DateTime? entryDate;
  String? logoHashId;
  late String hashId;

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
