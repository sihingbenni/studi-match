import 'package:studi_match/providers/config_provider.dart';

class EABaseService {
  
  final String baseUrl = ConfigProvider.baseUrl;
  final String jobSearchEndpoint = ConfigProvider.jobSearchEndpoint;
  final String jobLogoEndpoint = ConfigProvider.jobLogoEndpoint;
  final String oAuthEndpoint = ConfigProvider.oAuthEndpoint;

  final String clientId = ConfigProvider.clientId;
  final String clientSecret = ConfigProvider.clientSecret;
  final String grantType = ConfigProvider.grantType;

  final String bearerToken = ConfigProvider.bearerToken;
  final String bearerTokenValidUntil = ConfigProvider.bearerTokenValidUntil;

}
