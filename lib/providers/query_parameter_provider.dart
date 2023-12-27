import 'package:studi_match/models/query_parameters.dart';

class QueryParameterProvider {
  QueryParameters queryParameters = QueryParameters();

  getWithKeyword(String keyword) {
    queryParameters.jobDescription = keyword;
    return queryParameters;
  }

  void setDistance(int distance) {
    queryParameters.radius = 25;
  }

  void setLocation(String location) {
    queryParameters.where = location;
  }
}
