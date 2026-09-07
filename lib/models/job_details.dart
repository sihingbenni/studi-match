import 'package:studi_match/models/address.dart';
import 'package:studi_match/models/leadership_skills.dart';
import 'package:studi_match/models/mobility.dart';
import 'package:studi_match/models/working_time_model.dart';

class JobDetails {
  late final DateTime? currentPublicationDate;
  late final List<String>? alternativeProfessions;
  late final int? offerType;
  late final String? employer;
  late final String? branch;
  late final String? branchGroup;
  late final String? employerLogoHashId;
  late final String? employerHashId;
  late final String? customerNumberHash;
  late final String hashId;
  late final List<Address> workplaces;
  late final List<WorkingTimeModel> workingTimeModels;
  late final String? informationAboutWorkingTime;
  late final int? fixedTerm;
  late final bool? hasPossibilityOfPermanentEmployment;
  late final int? companySize;
  late final DateTime? entryDate;
  late final DateTime? firstPublicationDate;
  late final String? alliancePartner;
  late final String? alliancePartnerUrl;
  late final String? title;
  late final String? profession;
  late final DateTime? modificationTimestamp;
  late final String? jobDescription;
  late final String? referenceNr;
  late final String? collectiveAgreement; // tarifvertrag
  late final bool? suitableForRefugees;
  late final bool? onlyForSeverelyDisabled;
  late final int? numberOfOpenPositions;
  late final Address? employerAddress;
  late final Mobility? mobility;
  late final LeadershipSkills? leadershipSkills;
  late final String? employerPresentationUrl;
  late final String? employerPresentation;
  late final int? mainDkz; // Dokumentationskennziffer
  late final List<int>? alternativeDkzs;
  late final bool? isSupervised;
  late final bool? isPrivateEmploymentAgency;
  late final bool? isTemporaryEmployment;
  late final bool? isGoogleJobsRelevant;
  late final bool? isAnonymousAdvertisement;

  JobDetails.fromEAJson(Map<String, dynamic> json) {
    final pubDate = json['aktuelleVeroeffentlichungsdatum'] ??
        json['datumErsteVeroeffentlichung'] ??
        json['veroeffentlichungszeitraum']?['von'];
    currentPublicationDate =
        pubDate != null ? DateTime.tryParse(pubDate.toString()) : null;

    alternativeProfessions = (json['alternativBerufe'] is List)
        ? (json['alternativBerufe'] as List).map((e) => e.toString()).toList()
        : null;

    offerType =
        json['angebotsart'] != null ? int.tryParse(json['angebotsart'].toString()) : null;
    employer = (json['firma'] ?? json['arbeitgeber'])?.toString();
    branch = json['branche']?.toString();
    branchGroup = json['branchengruppe']?.toString();
    employerLogoHashId = (json['arbeitgeberKundennummerHash'] ??
            json['kundennummerHash'] ??
            json['arbeitgeberLogoHashId'])
        ?.toString();
    employerHashId = (json['arbeitgeberHashId'] ?? json['arbeitgeberKundennummerHash'])?.toString();
    customerNumberHash = (json['arbeitgeberKundennummerHash'] ?? json['kundennummerHash'])?.toString();
    hashId = (json['referenznummer'] ?? json['refnr'] ?? json['hashId'] ?? '')
        .toString();

    final locs = json['stellenlokationen'] ?? json['arbeitsorte'];
    workplaces = locs != null && locs is List
        ? locs.map<Address>(Address.fromEAJson).toList()
        : List.empty();

    workingTimeModels = json['arbeitszeitmodelle'] != null && json['arbeitszeitmodelle'] is List
        ? (json['arbeitszeitmodelle'] as List)
            .map<WorkingTimeModel>(WorkingTimeModel.fromEAJson)
            .toList()
        : List.empty();

    informationAboutWorkingTime = json['informationenZurArbeitszeit']?.toString();
    fixedTerm = json['befristungInMonaten'] is num
        ? (json['befristungInMonaten'] as num).toInt()
        : (json['befristung'] != null
            ? int.tryParse(json['befristung'].toString())
            : null);
    hasPossibilityOfPermanentEmployment = json['uebernahme'];
    companySize = json['betriebsgroesse'] != null
        ? int.tryParse(json['betriebsgroesse'].toString())
        : null;

    final entryDateStr = json['eintrittsdatum'] ?? json['eintrittszeitraum']?['von'];
    entryDate =
        entryDateStr != null ? DateTime.tryParse(entryDateStr.toString()) : null;

    final firstPubStr = json['ersteVeroeffentlichungsdatum'] ?? json['datumErsteVeroeffentlichung'];
    firstPublicationDate =
        firstPubStr != null ? DateTime.tryParse(firstPubStr.toString()) : null;

    alliancePartner = (json['allianzpartnerName'] ?? json['allianzpartner'])?.toString();
    alliancePartnerUrl = json['allianzpartnerUrl']?.toString();
    title = (json['stellenangebotsTitel'] ?? json['titel'])?.toString();
    profession = (json['hauptberuf'] ?? json['beruf'])?.toString();

    final modStr = json['modifikationsTimestamp'] ?? json['aenderungsdatum'];
    modificationTimestamp =
        modStr != null ? DateTime.tryParse(modStr.toString()) : null;

    jobDescription = (json['stellenangebotsBeschreibung'] ?? json['stellenbeschreibung'])?.toString();
    referenceNr = (json['referenznummer'] ?? json['refnr'])?.toString();
    collectiveAgreement = json['tarifvertrag']?.toString();
    suitableForRefugees = json['fuerFluechtlingeGeeignet'];
    onlyForSeverelyDisabled = json['nurFuerSchwerbehinderte'];
    numberOfOpenPositions = json['anzahlOffeneStellen'] != null
        ? int.tryParse(json['anzahlOffeneStellen'].toString())
        : null;
    employerAddress = json['arbeitgeberAdresse'] != null
        ? Address.fromEAJson(json['arbeitgeberAdresse'])
        : null;
    mobility = json['mobilitaet'] != null ? Mobility.fromEAJson(json['mobilitaet']) : null;
    leadershipSkills = json['fuehrungskompetenzen'] != null
        ? LeadershipSkills.fromEAJson(json['fuehrungskompetenzen'])
        : null;
    employerPresentationUrl = json['arbeitgeberdarstellungUrl']?.toString();
    employerPresentation = json['arbeitgeberdarstellung']?.toString();
    mainDkz = json['hauptDkz'] != null ? int.tryParse(json['hauptDkz'].toString()) : null;
    alternativeDkzs = (json['alternativDkzs'] is List)
        ? (json['alternativDkzs'] as List)
            .map((e) => int.tryParse(e.toString()))
            .whereType<int>()
            .toList()
        : null;
    isSupervised = json['istBetreut'];
    isPrivateEmploymentAgency = json['istPrivateArbeitsvermittlung'];
    isTemporaryEmployment = json['istZeitarbeit'];
    isGoogleJobsRelevant = json['istGoogleJobsRelevant'];
    isAnonymousAdvertisement = json['anzeigeAnonym'];
  }

  @override
  String toString() => 'JobDetails: $title';
}
