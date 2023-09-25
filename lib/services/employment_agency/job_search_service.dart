import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:studi_match/models/employment_agency/job_search_response.dart';
import 'package:studi_match/models/employment_agency/query_parameters.dart';
import 'package:studi_match/services/employment_agency/base_service.dart';
import 'package:studi_match/services/employment_agency/oauth_service.dart';
import 'package:studi_match/utilities/logger.dart';


class EAJobSearchService extends EABaseService {

  /// Calls the Employment Agency Jobs Api and returns the response.
  Future<JobSearchResponse> callJobsApi(QueryParameters queryParameters) async {
    logger.d('fetching List of Jobs from the Employment Agency Api');

    // transform the query parameters to a map
    final queryParametersMap = queryParameters.toMap();

    // get a valid Oauth token
    String oauthToken = await EAOAuthService().getApiToken();

    // create header
    var headers = {
      'Authorization': 'Bearer $oauthToken',
    };

    // create uri, check if there are any query parameters, if yes use them, else not
    final uri = queryParametersMap.isNotEmpty
        ? Uri.https(baseUrl, jobSearchEndpoint, queryParametersMap)
        : Uri.https(baseUrl, jobSearchEndpoint);
    // create request
    var request = http.Request('GET', uri);
    // add header to request
    request.headers.addAll(headers);

    // declare response Object
    http.StreamedResponse response;
    logger.d('Starting the Request now!');
    try {
      // execute request
      response = await request.send();
    } catch (e) {
      logger.e('Failed to fetch the Employment Agency Jobs List!');
      //TODO handle the error
      throw Exception();
    }

    if (response.statusCode == 200) {
      logger.d('Employment Agency Jobs List fetched successfully!');
      final responseString = await response.stream.bytesToString();

      // decode the response json and return it
      return JobSearchResponse.fromEAJson(jsonDecode(responseString));
    } else {
      logger.e(response.reasonPhrase);
      //TODO handle the error
      throw Exception(
          'Failed to fetch the Employment Agency Jobs List! used QueryParameters: $queryParametersMap');
    }
  }
}
