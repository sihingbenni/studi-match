import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/services/employment_agency/base_service.dart';

@deprecated
class EAOAuthService extends EABaseService {
  static final EAOAuthService _singleton = EAOAuthService._internal();

  factory EAOAuthService() => _singleton;

  EAOAuthService._internal();

  /// Deprecated: BA API now uses X-API-Key instead of OAuth Bearer token.
  Future<String> getApiToken() async {
    return ConfigProvider.apiKey;
  }
}
