import 'package:flutter/material.dart';
import 'package:studi_match/providers/config_provider.dart';

class EABaseService {
  @protected
  final String baseUrl = ConfigProvider().get('employmentAgencyService')['baseUrl'];
  @protected
  final String odataEndpoint = ConfigProvider().get('employmentAgencyService')['oAuthEndpoint'];
  @protected
  final String jobSearchEndpoint =
      ConfigProvider().get('employmentAgencyService')['jobSearchEndpoint'];
  @protected
  final String clientId = ConfigProvider().get('employmentAgencyService')['clientId'];
  @protected
  final String clientSecret = ConfigProvider().get('employmentAgencyService')['clientSecret'];
  @protected
  final String grantType = ConfigProvider().get('employmentAgencyService')['grantType'];
}
