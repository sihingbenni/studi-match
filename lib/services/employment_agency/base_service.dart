import 'package:http/http.dart' as http;
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/utilities/logger.dart';

abstract class EABaseService {
  final String baseUrl = ConfigProvider.baseUrl;
  final String jobSearchEndpoint = ConfigProvider.jobSearchEndpoint;
  final String jobLogoEndpoint = ConfigProvider.jobLogoEndpoint;
  final String jobDetailsEndpoint = ConfigProvider.jobDetailsEndpoint;

  Map<String, String> _getHeaders() => {
        'Accept': 'application/json',
        ConfigProvider.apiKeyHeader: ConfigProvider.apiKey,
      };

  Future<String> sendRequest(Uri uri) async {
    // get the headers
    final headers = _getHeaders();

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
      throw Exception();
    }

    if (response.statusCode == 200) {
      logger.d('Request to ${uri.path} Successful!');
      return await response.stream.bytesToString();
    } else {
      logger.e(response.reasonPhrase);
      throw Exception(
          'Request to ${uri.path} Failed! Response Code: ${response.statusCode}');
    }
  }
}
