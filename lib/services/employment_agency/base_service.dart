import 'package:http/http.dart' as http;
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/services/employment_agency/oauth_service.dart';
import 'package:studi_match/utilities/logger.dart';

abstract class EABaseService {
  final String baseUrl = ConfigProvider.baseUrl;
  final String jobSearchEndpoint = ConfigProvider.jobSearchEndpoint;
  final String jobLogoEndpoint = ConfigProvider.jobLogoEndpoint;
  final String oAuthEndpoint = ConfigProvider.oAuthEndpoint;
  final String jobDetailsEndpoint = ConfigProvider.jobDetailsEndpoint;

  final String clientId = ConfigProvider.clientId;
  final String clientSecret = ConfigProvider.clientSecret;
  final String grantType = ConfigProvider.grantType;

  final String bearerToken = ConfigProvider.bearerToken;
  final String bearerTokenValidUntil = ConfigProvider.bearerTokenValidUntil;

  Future<Map<String, String>> _getHeaders() async => {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await EAOAuthService().getApiToken()}',
      };

  Future<String> sendRequest(Uri uri) async {
    // get the headers
    final headers = await _getHeaders();

    // create request
    var request = http.Request('GET', uri);
    // add header to request
    request.headers.addAll(headers);

    // declare response Object
    http.StreamedResponse response;
    logger.d('Starting the Request to ${uri.path} ...');

    try {
      // execute request
      response = await request.send();
    } catch (e) {
      logger.e('Request to ${uri.pathSegments.last} Failed');
      //TODO handle the error
      throw Exception();
    }

    if (response.statusCode == 200) {
      logger.d('Request to ${uri.path} Successful!');
      return await response.stream.bytesToString();
    } else {
      logger.e(response.reasonPhrase);
      //TODO handle the error
      throw Exception(
          'Request to ${uri.path} Failed! Response Code: ${response.statusCode}');
    }
  }
}
