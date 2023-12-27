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
    currentPublicationDate = json['aktuelleVeroeffentlichungsdatum'] != null
        ? DateTime.parse(json['aktuelleVeroeffentlichungsdatum'])
        : null;
    alternativeProfessions = json['alternativBerufe']?.cast<String>();
    offerType =
        json['angebotsart'] != null ? int.parse(json['angebotsart']) : null;
    employer = json['arbeitgeber'];
    branch = json['branche'];
    branchGroup = json['branchengruppe'];
    employerLogoHashId = json['arbeitgeberLogoHashId'];
    employerHashId = json['arbeitgeberHashId'];
    customerNumberHash = json['kundennummerHash'];
    hashId = json['hashId'];
    workplaces = json['arbeitsorte'] != null
        ? json['arbeitsorte'].map<Address>(Address.fromEAJson).toList()
        : List.empty();
    workingTimeModels = json['arbeitszeitmodelle'] != null
        ? json['arbeitszeitmodelle']
            .map<WorkingTimeModel>(WorkingTimeModel.fromEAJson)
            .toList()
        : List.empty();
    informationAboutWorkingTime = json['informationenZurArbeitszeit'];
    fixedTerm =
        json['befristung'] != null ? int.parse(json['befristung']) : null;
    hasPossibilityOfPermanentEmployment = json['uebernahme'];
    companySize = (json['betriebsgroesse'] != null)
        ? int.parse(json['betriebsgroesse'])
        : null;
    entryDate = json['eintrittsdatum'] != null
        ? DateTime.parse(json['eintrittsdatum'])
        : null;
    firstPublicationDate = json['ersteVeroeffentlichungsdatum'] != null
        ? DateTime.parse(json['ersteVeroeffentlichungsdatum'])
        : null;
    alliancePartner = json['allianzpartner'];
    alliancePartnerUrl = json['allianzpartnerUrl'];
    title = json['titel'];
    profession = json['beruf'];
    modificationTimestamp = json['modifikationsTimestamp'] != null
        ? DateTime.parse(json['modifikationsTimestamp'])
        : null;
    jobDescription = json['stellenbeschreibung'];
    referenceNr = json['refnr'];
    collectiveAgreement = json['tarifvertrag'];
    suitableForRefugees = json['fuerFluechtlingeGeeignet'];
    onlyForSeverelyDisabled = json['nurFuerSchwerbehinderte'];
    numberOfOpenPositions =
        json['anzahlOffeneStellen']; // this is already an int
    employerAddress = Address.fromEAJson(json['arbeitgeberAdresse']);
    mobility = Mobility.fromEAJson(json['mobilitaet']);
    leadershipSkills =
        LeadershipSkills.fromEAJson(json['fuehrungskompetenzen']);
    employerPresentationUrl = json['arbeitgeberdarstellungUrl'];
    employerPresentation = json['arbeitgeberdarstellung'];
    mainDkz = json['hauptDkz'] != null ? int.parse(json['hauptDkz']) : null;
    alternativeDkzs = json['alternativDkzs']?.cast<int>();
    isSupervised = json['istBetreut'];
    isPrivateEmploymentAgency = json['istPrivateArbeitsvermittlung'];
    isTemporaryEmployment = json['istZeitarbeit'];
    isGoogleJobsRelevant = json['istGoogleJobsRelevant'];
    isAnonymousAdvertisement = json['anzeigeAnonym'];
  }

  @override
  String toString() => 'JobDetails: $title';
}
