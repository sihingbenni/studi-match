class Facets {
  FixedTerm? fixedTerm;
  Disability? disability;
  PrivateEmploymentAgency? privateEmploymentAgency;
  FieldOfWork? fieldOfWork;
  Workplace? workplace;

  // late final TypeOfTraining typeOfTraining;
  PublishedSince? publishedSince;

  // late final Education education;
  WorkplaceZipCode? workplaceZipCode;
  Employer? employer;
  Profession? profession;
  Industry? industry;
  WorkingHours? workingHours;
  EntryDate? entryDate;
  TemporaryWork? temporaryWork;
  Corona? corona;
  LeadershipResponsibility? leadershipResponsibility;

  Facets.fromEAJson(Map<String, dynamic> json) {
    fixedTerm = FixedTerm.fromEAJson(json['befristung']);
    disability = Disability.fromEAJson(json['behinderung']);
    privateEmploymentAgency = PrivateEmploymentAgency.fromEAJson(json['pav']);
    fieldOfWork = FieldOfWork.fromEAJson(json['berufsfeld']);
    workplace = Workplace.fromEAJson(json['arbeitsort']);
    // typeOfTraining = TypeOfTraining.fromEAJson(json['ausbildungsart']);
    publishedSince = PublishedSince.fromEAJson(json['veroeffentlichtseit']);
    // education = Education.fromEAJson(json['schulbildung']);
    workplaceZipCode = WorkplaceZipCode.fromEAJson(json['arbeitsort_plz']);
    employer = Employer.fromEAJson(json['arbeitgeber']);
    profession = Profession.fromEAJson(json['beruf']);
    industry = Industry.fromEAJson(json['branche']);
    workingHours = WorkingHours.fromEAJson(json['arbeitszeit']);
    entryDate = EntryDate.fromEAJson(json['eintrittsdatum']);
    temporaryWork = TemporaryWork.fromEAJson(json['zeitarbeit']);
    corona = Corona.fromEAJson(json['corona']);
    leadershipResponsibility = LeadershipResponsibility.fromEAJson(json['fuehrungsverantwortung']);
  }
}

abstract class Facet {
  late final Map<String, int> counts;
  late final int maxCount;

  Facet.fromEAJson(Map<String, dynamic>? json) {
    if (json == null) {
      counts = {};
      maxCount = 0;
      return;
    }
    counts = json['counts'].cast<String, int>();
    maxCount = json['maxCount']!;
  }
}

class FixedTerm extends Facet {
  FixedTerm.fromEAJson(super.json) : super.fromEAJson();
}

class Disability extends Facet {
  Disability.fromEAJson(super.json) : super.fromEAJson();
}

class PrivateEmploymentAgency extends Facet {
  PrivateEmploymentAgency.fromEAJson(super.json) : super.fromEAJson();
}

class FieldOfWork extends Facet {
  FieldOfWork.fromEAJson(super.json) : super.fromEAJson();
}

class Workplace extends Facet {
  Workplace.fromEAJson(super.json) : super.fromEAJson();
}

class TypeOfTraining extends Facet {
  TypeOfTraining.fromEAJson(super.json) : super.fromEAJson();
}

class PublishedSince extends Facet {
  PublishedSince.fromEAJson(super.json) : super.fromEAJson();
}

class Education extends Facet {
  Education.fromEAJson(super.json) : super.fromEAJson();
}

class WorkplaceZipCode extends Facet {
  WorkplaceZipCode.fromEAJson(super.json) : super.fromEAJson();
}

class Employer extends Facet {
  Employer.fromEAJson(super.json) : super.fromEAJson();
}

class Profession extends Facet {
  Profession.fromEAJson(super.json) : super.fromEAJson();
}

class Industry extends Facet {
  Industry.fromEAJson(super.json) : super.fromEAJson();
}

class WorkingHours extends Facet {
  WorkingHours.fromEAJson(super.json) : super.fromEAJson();
}

class EntryDate extends Facet {
  EntryDate.fromEAJson(super.json) : super.fromEAJson();
}

class TemporaryWork extends Facet {
  TemporaryWork.fromEAJson(super.json) : super.fromEAJson();
}

class Corona extends Facet {
  Corona.fromEAJson(super.json) : super.fromEAJson();
}

class LeadershipResponsibility extends Facet {
  LeadershipResponsibility.fromEAJson(super.json) : super.fromEAJson();
}
