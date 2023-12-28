import 'dart:convert';

import 'package:studi_match/models/job_search_response.dart';
import 'package:studi_match/models/query_parameters.dart';
import 'package:studi_match/services/employment_agency/base_service.dart';
import 'package:studi_match/utilities/logger.dart';

class EAJobSearchService extends EABaseService {
  /// Calls the Employment Agency Jobs Api and returns the response.
  Future<JobSearchResponse> callJobsApi(QueryParameters queryParameters) async {
    logger.d('fetching List of Jobs from the Employment Agency Api');

    // transform the query parameters to a map
    final queryParametersMap = queryParameters.toMap();

    // create uri, check if there are any query parameters, if yes use them, else not
    final uri = queryParametersMap.isNotEmpty
        ? Uri.https(baseUrl, jobSearchEndpoint, queryParametersMap)
        : Uri.https(baseUrl, jobSearchEndpoint);

    try {
      // send the request
      final responseString = await sendRequest(uri);

      // decode the response json and return it
      return JobSearchResponse.fromEAJson(jsonDecode(responseString));
    } catch (e) {
      logger.e(
          'Failed to fetch the Employment Agency Jobs List!\nused QueryParameters: $queryParametersMap');
      // show error in Snackbar

      throw Exception();
    }
  }
}
