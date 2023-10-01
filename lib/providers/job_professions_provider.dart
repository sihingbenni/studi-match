import 'package:flutter/material.dart';
import 'package:studi_match/models/query_parameters.dart';
import 'package:studi_match/services/employment_agency/job_search_service.dart';

class JobProfessionsProvider extends ChangeNotifier {
  final _queryParameters = QueryParameters();
  final _service = EAJobSearchService();

  List<String> _fieldOfWorks = [];

  List<String> get fieldOfWorks => _fieldOfWorks;

  JobProfessionsProvider() {
    _queryParameters.size = 1;
    _queryParameters.profession = 'Non existing field of Work';
    getProfessions();
  }

  void getProfessions() => _service.callJobsApi(_queryParameters).then((response) {
        if (response.facets.fieldOfWork != null) {
          _fieldOfWorks = response.facets.fieldOfWork!.counts.keys.toList();
          notifyListeners();
        }
      });
}
