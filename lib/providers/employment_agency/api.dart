import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studi_match/models/employment_agency_api_responses/job_search_response.dart';
import 'package:studi_match/models/employment_agency_api_responses/oauth_response.dart';
import 'package:studi_match/utilities/global_constants.dart' as global_constants;
import 'package:studi_match/utilities/logger.dart';

class EmploymentAgencyApi {
  static const String baseUrl = 'rest.arbeitsagentur.de';
  static const String odataEndpoint = '/oauth/gettoken_cc';
  static const String jobSearchEndpoint = '/jobboerse/jobsuche-service/pc/v4/jobs';
  static const String clientId = 'c003a37f-024f-462a-b36d-b001be4cd24a';
  static const String clientSecret = '32a39620-32b3-4307-9aa1-511e3d7f48a8';
  static const String grantType = 'client_credentials';

  /// Calls the Employment Agency Jobs Api and returns the response.
  static Future<JobSearchResponse> callJobsApi(Map<String, String> queryParameters) async {
    logger.d('fetching List of Jobs from the Employment Agency Api');

    // get a valid Oauth token
    String oauthToken = await _getApiToken();

    // create header
    var headers = {
      'Authorization': 'Bearer $oauthToken',
    };

    // create uri, check if there are any query parameters, if yes use them, else not
    final uri = queryParameters.isNotEmpty
        ? Uri.https(baseUrl, jobSearchEndpoint, queryParameters)
        : Uri.https(baseUrl, jobSearchEndpoint);
    // create request
    var request = http.Request('GET', uri);
    // add header to request
    request.headers.addAll(headers);

    // declare response Object
    http.StreamedResponse response;

    try {
      // execute request
      response = await request.send();
    } catch (e) {
      logger.e('Failed to fetch the Employment Agency Jobs List');
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
      throw Exception('Failed to fetch the Employment Agency Api Token');
    }
  }

  /// checks if there is a valid Oauth token, if yes return it.
  /// if not fetch a new one and return it.
  static Future<String> _getApiToken() async {
    logger.d('checking if there is a valid Employment Agency Oauth Token');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(global_constants.prefsEABearerToken);
    String? tokenValidUntil = prefs.getString(global_constants.prefsEATokenValidUntil);

    if (token == null || tokenValidUntil == null) {
      // no token in the shared preferences
      // fetch a new one
      logger.d('no valid Employment Agency Oauth Token found');
      return await _refreshApiToken();
    } else {
      // token in the shared preferences
      // check if it is still valid
      DateTime tokenValidUntilDateTime = DateTime.parse(tokenValidUntil).toLocal();
      if (tokenValidUntilDateTime.isBefore(DateTime.now())) {
        // token is expired
        // fetch a new one
        logger.d('an old Employment Agency Oauth Token was found');
        return await _refreshApiToken();
      } else {
        // token is still valid
        // return it
        logger.d('a valid Employment Agency Oauth Token was found');
        return token;
      }
    }
  }

  /// Refreshes the Oauth Token by calling the Employment Agency Oauth Api
  /// and returns the new token.
  static Future<String> _refreshApiToken() async => await callOauthApi().then((value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // save the token to the shared preferences
        prefs.setString(global_constants.prefsEABearerToken, value.accessToken);
        // save when the token expires to the preferences
        prefs.setString(global_constants.prefsEATokenValidUntil, value.expiresAt.toString());
        return value.accessToken;
      });

  /// Calls the Employment Agency Oauth Api and returns the response.
  static Future<OauthResponse> callOauthApi() async {
    logger.d('fetching a new Employment Agency Oauth Token');

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json'
    };

    // create uri
    final uri = Uri.https(baseUrl, odataEndpoint);
    // create request
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'client_id': clientId,
      'client_secret': clientSecret,
      'grant_type': grantType
    };
    request.headers.addAll(headers);

    // declare response Object
    http.StreamedResponse response;

    try {
      // execute request
      response = await request.send();
    } catch (e) {
      //TODO handle the error
      logger.e('Failed to fetch the Employment Agency Api Token');
      //TODO handle the error
      throw Exception();
    }

    if (response.statusCode == 200) {
      // Success
      logger.d('Employment Agency Api Token fetched successfully!');
      String responseString = await response.stream.bytesToString();

      // decode the response json and return it
      return OauthResponse.fromEAJson(jsonDecode(responseString));
    } else {
      // Failure
      logger.e(response.reasonPhrase);
      //TODO handle the error
      throw Exception('Failed to fetch the Employment Agency Api Token');
    }
  }
}
