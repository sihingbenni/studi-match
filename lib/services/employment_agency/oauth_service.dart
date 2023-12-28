import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studi_match/models/oauth_response.dart';
import 'package:studi_match/services/employment_agency/base_service.dart';
import 'package:studi_match/utilities/logger.dart';

class EAOAuthService extends EABaseService {
  bool _isFetchingToken = false;

  static final EAOAuthService _singleton = EAOAuthService._internal();

  factory EAOAuthService() => _singleton;

  EAOAuthService._internal();

  /// checks if there is a valid Oauth token, if yes return it.
  /// if not fetch a new one and return it.
  Future<String> getApiToken() async {
    logger.t('checking if there is a valid Employment Agency Oauth Token');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(bearerToken);
    String? tokenValidUntil = prefs.getString(bearerTokenValidUntil);

    if (token == null || tokenValidUntil == null) {
      // no token in the shared preferences
      // fetch a new one
      logger.d('no valid Employment Agency Oauth Token found');

      // check if there is already a request to fetch a token
      if (_isFetchingToken) {
        logger.d(
            'a request to fetch a new Employment Agency Oauth Token is already running');
        // wait until the token is fetched
        while (_isFetchingToken) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        // return the token
        return await getApiToken();
      }

      return await _refreshApiToken();
    } else {
      // token in the shared preferences
      // check if it is still valid
      DateTime tokenValidUntilDateTime =
          DateTime.parse(tokenValidUntil).toLocal();
      if (tokenValidUntilDateTime.isBefore(DateTime.now())) {
        // token is expired
        // fetch a new one
        logger.d('an old Employment Agency Oauth Token was found');
        return await _refreshApiToken();
      } else {
        // token is still valid
        // return it
        logger.t('a valid Employment Agency Oauth Token was found');
        return token;
      }
    }
  }

  /// Refreshes the Oauth Token by calling the Employment Agency Oauth Api
  /// and returns the new token.
  Future<String> _refreshApiToken() async {
    _isFetchingToken = true;
    return await callOauthApi().then((value) async {
      // set the fetching token flag to true
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // save the token to the shared preferences
      prefs.setString(bearerToken, value.accessToken);
      // save when the token expires to the preferences
      prefs.setString(bearerTokenValidUntil, value.expiresAt.toString());
      _isFetchingToken = false;
      return value.accessToken;
    });
  }

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
      logger.e('Failed to fetch the Employment Agency Api Token');
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

      throw Exception('Failed to fetch the Employment Agency Api Token');
    }
  }
}
