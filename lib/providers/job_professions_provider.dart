import 'package:flutter/material.dart';
import 'package:studi_match/models/query_parameters.dart';
import 'package:studi_match/services/employment_agency/job_search_service.dart';

/// Provider for the list of existing job professions.
class JobProfessionsProvider extends ChangeNotifier {
  final _queryParameters = QueryParameters();
  final _service = EAJobSearchService();

  List<String> _fieldOfWorks = [];

  List<String> get fieldOfWorks => _fieldOfWorks;

  /// Construct the JobProfessionsProvider and start getting the list of professions.
  /// Configure the query parameters to only get the fieldOfWorks facet.
  JobProfessionsProvider() {
    _queryParameters.size = 1;
    _queryParameters.profession = 'Non existing field of Work';
    getProfessions();
  }

  /// Sends a simplified request to the job search api endpoint to get a list of all professions.
  /// This list contains only the fieldOfWorks facet.
  void getProfessions() => _service.callJobsApi(_queryParameters).then((response) {
        if (response.facets.fieldOfWork != null) {
          _fieldOfWorks = response.facets.fieldOfWork!.counts.keys.toList();
          notifyListeners();
        }
      });
}
