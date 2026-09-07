class Facets {
  late final FixedTerm? fixedTerm;
  late final Disability? disability;
  late final PrivateEmploymentAgency? privateEmploymentAgency;
  late final FieldOfWork? fieldOfWork;
  late final Workplace? workplace;

  late final PublishedSince? publishedSince;

  late final WorkplaceZipCode? workplaceZipCode;
  late final Employer? employer;
  late final Profession? profession;
  late final Industry? industry;
  late final WorkingHours? workingHours;
  late final EntryDate? entryDate;
  late final TemporaryWork? temporaryWork;
  late final Corona? corona;
  late final LeadershipResponsibility? leadershipResponsibility;

  Facets.fromEAJson(dynamic json) {
    final map = (json is Map) ? json : {};
    fixedTerm = map['befristung'] != null
        ? FixedTerm.fromEAJson((map['befristung'] as Map).cast<String, dynamic>())
        : null;
    disability = map['behinderung'] != null
        ? Disability.fromEAJson((map['behinderung'] as Map).cast<String, dynamic>())
        : null;
    privateEmploymentAgency = map['pav'] != null
        ? PrivateEmploymentAgency.fromEAJson((map['pav'] as Map).cast<String, dynamic>())
        : null;
    fieldOfWork = map['berufsfeld'] != null
        ? FieldOfWork.fromEAJson((map['berufsfeld'] as Map).cast<String, dynamic>())
        : null;
    workplace = map['arbeitsort'] != null
        ? Workplace.fromEAJson((map['arbeitsort'] as Map).cast<String, dynamic>())
        : null;
    publishedSince = map['veroeffentlichtseit'] != null
        ? PublishedSince.fromEAJson((map['veroeffentlichtseit'] as Map).cast<String, dynamic>())
        : null;
    workplaceZipCode = map['arbeitsort_plz'] != null
        ? WorkplaceZipCode.fromEAJson((map['arbeitsort_plz'] as Map).cast<String, dynamic>())
        : null;
    employer = map['arbeitgeber'] != null
        ? Employer.fromEAJson((map['arbeitgeber'] as Map).cast<String, dynamic>())
        : null;
    profession = map['beruf'] != null
        ? Profession.fromEAJson((map['beruf'] as Map).cast<String, dynamic>())
        : null;
    industry = map['branche'] != null
        ? Industry.fromEAJson((map['branche'] as Map).cast<String, dynamic>())
        : null;
    workingHours = map['arbeitszeit'] != null
        ? WorkingHours.fromEAJson((map['arbeitszeit'] as Map).cast<String, dynamic>())
        : null;
    entryDate = map['eintrittsdatum'] != null
        ? EntryDate.fromEAJson((map['eintrittsdatum'] as Map).cast<String, dynamic>())
        : null;
    temporaryWork = map['zeitarbeit'] != null
        ? TemporaryWork.fromEAJson((map['zeitarbeit'] as Map).cast<String, dynamic>())
        : null;
    corona = map['corona'] != null
        ? Corona.fromEAJson((map['corona'] as Map).cast<String, dynamic>())
        : null;
    leadershipResponsibility = map['fuehrungsverantwortung'] != null
        ? LeadershipResponsibility.fromEAJson((map['fuehrungsverantwortung'] as Map).cast<String, dynamic>())
        : null;
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
    counts = json['counts'] != null
        ? (json['counts'] as Map).map((k, v) => MapEntry(k.toString(), (v is num) ? v.toInt() : 0))
        : {};
    maxCount = (json['maxCount'] is num)
        ? (json['maxCount'] as num).toInt()
        : (int.tryParse(json['maxCount']?.toString() ?? '0') ?? 0);
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
