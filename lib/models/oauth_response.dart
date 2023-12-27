class OauthResponse {
  late final String accessToken;
  late final String tokenType;
  late final DateTime expiresAt;
  late final String scope;
  late final String clientId;
  late final String type;

  OauthResponse.fromEAJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    // calculate the expiration date
    expiresAt = DateTime.now().add(Duration(seconds: json['expires_in']));
    scope = json['scope'];
    clientId = json['clientid'];
    type = json['type'];
  }
}
