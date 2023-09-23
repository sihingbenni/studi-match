

class QueryParameters {

  String? jobDescription;
  String? where;
  String? profession;
  int? page = 1;
  int? size = 50;
  String? employer;
  int? publishedSince;
  bool? temporaryWork;
  int? typeOfOffer;
  String? limitedWork;
  String? workingHours;
  bool? workWithDisability;
  bool? corona;
  int? radius;



  Map<String, String> toMap() => {
      'was': jobDescription ?? '',
      'wo': where ?? '',
      'berufsfeld': profession ?? '',
      'page': page == null ? page.toString() : '',
      'size': size == null ? size.toString() : '',
      'arbeitgeber': employer ?? '',
      'veroeffentlichtseit': publishedSince == null ? publishedSince.toString() : '',
      'zeitarbeit': temporaryWork == null ? temporaryWork.toString() : '',
      'angebotsart': typeOfOffer == null ? typeOfOffer.toString() : '',
      'befristung': limitedWork ?? '',
      'arbeitszeit': workingHours ?? '',
      'behinderung': workWithDisability == null ? workWithDisability.toString() : '',
      'corona': corona == null ? corona.toString() : '',
      'umkreis': radius == null ? radius.toString() : '',
    };
}
