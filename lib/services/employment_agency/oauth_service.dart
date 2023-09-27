import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studi_match/models/employment_agency/oauth_response.dart';
import 'package:studi_match/services/employment_agency/base_service.dart';
import 'package:studi_match/utilities/logger.dart';


class EAOAuthService extends EABaseService {


  /// checks if there is a valid Oauth token, if yes return it.
  /// if not fetch a new one and return it.
  Future<String> getApiToken() async {
    logger.d('checking if there is a valid Employment Agency Oauth Token');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(bearerToken);
    String? tokenValidUntil = prefs.getString(bearerTokenValidUntil);

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
  Future<String> _refreshApiToken() async => await callOauthApi().then((value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // save the token to the shared preferences
        prefs.setString(bearerToken, value.accessToken);
        // save when the token expires to the preferences
        prefs.setString(bearerTokenValidUntil, value.expiresAt.toString());
        return value.accessToken;
      });

  /// Calls the Employment Agency Oauth Api and returns the response.
  Future<OauthResponse> callOauthApi() async {
    logger.d('fetching a new Employment Agency Oauth Token');

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json'
    };

    // create uri
    final uri = Uri.https(baseUrl, oAuthEndpoint);
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
