

import 'package:studi_match/models/leadership_skills.dart';
import 'package:studi_match/models/mobility.dart';
import 'package:studi_match/models/working_time_model.dart';
import 'package:studi_match/models/workplace.dart';

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
  late final String? hashId;
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
    currentPublicationDate = DateTime.parse(json['aktuelleVeroeffentlichungsdatum']);
    alternativeProfessions = json['alternativBerufe']?.cast<String>();
    offerType = int.parse(json['angebotsart']);
    employer = json['arbeitgeber'];
    branch = json['branche'];
    branchGroup = json['branchengruppe'];
    employerLogoHashId = json['arbeitgeberLogoHashId'];
    employerHashId = json['arbeitgeberHashId'];
    customerNumberHash = json['kundennummerHash'];
    hashId = json['hashId'];
    //workplaces = json['arbeitsorte'].map<Address>(Address.fromEAJson).toList();
    workingTimeModels = json['arbeitszeitmodelle'].map<WorkingTimeModel>(WorkingTimeModel.fromEAJson).toList();
    informationAboutWorkingTime = json['informationenZurArbeitszeit'];
    fixedTerm = int.parse(json['befristung']);
    hasPossibilityOfPermanentEmployment = json['uebernahme'];
    companySize = int.parse(json['betriebsgroesse']);
    entryDate = DateTime.parse(json['eintrittsdatum']);
    firstPublicationDate = DateTime.parse(json['ersteVeroeffentlichungsdatum']);
    alliancePartner = json['allianzpartner'];
    alliancePartnerUrl = json['allianzpartnerUrl'];
    title = json['titel'];
    profession = json['beruf'];
    modificationTimestamp = DateTime.parse(json['modifikationsTimestamp']);
    jobDescription = json['stellenbeschreibung'];
    referenceNr = json['refnr'];
    collectiveAgreement = json['tarifvertrag'];
    suitableForRefugees = json['fuerFluechtlingeGeeignet'];
    onlyForSeverelyDisabled = json['nurFuerSchwerbehinderte'];
    numberOfOpenPositions = int.parse(json['anzahlOffeneStellen']);
    employerAddress = Address.fromEAJson(json['arbeitgeberAdresse']);
    mobility = Mobility.fromEAJson(json['mobilitaet']);
    leadershipSkills = LeadershipSkills.fromEAJson(json['fuehrungskompetenzen']);
    employerPresentationUrl = json['arbeitgeberdarstellungUrl'];
    employerPresentation = json['arbeitgeberdarstellung'];
    mainDkz = int.parse(json['hauptDkz']);
    alternativeDkzs = json['alternativDkzs']?.cast<int>();
    isSupervised = json['istBetreut'];
    isPrivateEmploymentAgency = json['istPrivateArbeitsvermittlung'];
    isTemporaryEmployment = json['istZeitarbeit'];
    isGoogleJobsRelevant = json['istGoogleJobsRelevant'];
    isAnonymousAdvertisement = json['anzeigeAnonym'];
  }
}
