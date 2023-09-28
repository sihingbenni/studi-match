import 'package:flutter/material.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/services/employment_agency/oauth_service.dart';

class JobLogoProvider {
  static Future<ImageProvider> getLogo(String? logoHashId) async {
    if (logoHashId != null && logoHashId.isNotEmpty) {
      return NetworkImage(
          'https://'
              '${ConfigProvider.baseUrl}/'
              '${ConfigProvider.jobLogoEndpoint}/'
              '$logoHashId',
          headers: {
            'Authorization': 'Bearer ${await EAOAuthService().getApiToken()}',
            'Content-Type': 'image/png'
          });
    }
    // TODO return a placeholder image
    return const NetworkImage('https://via.placeholder.com/150');
  }
}
