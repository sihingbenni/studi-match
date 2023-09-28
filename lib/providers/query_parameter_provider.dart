

import 'package:studi_match/models/query_parameters.dart';

class QueryParameterProvider {



  getWithKeyword(String keyword) {
    final queryParameters = QueryParameters();

    // TODO fill with personal Preferences
    queryParameters.where = 'Sophienblatt 48B, 24114 Kiel';
    queryParameters.radius = 25;

    queryParameters.jobDescription = keyword;
    return queryParameters;
  }

}