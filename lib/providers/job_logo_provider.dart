import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/services/employment_agency/oauth_service.dart';

/// This class provides the Job Logo from the Employment Agency Api
class JobLogoProvider {

  /// Returns the Job Logo as a CachedNetworkImage Widget
  static Future<StatelessWidget> getLogo(String? logoHashId) async {
    if (logoHashId != null && logoHashId.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: 'https://'
            '${ConfigProvider.baseUrl}/'
            '${ConfigProvider.jobLogoEndpoint}/'
            '$logoHashId',
        httpHeaders: {
          'Authorization': 'Bearer ${await EAOAuthService().getApiToken()}',
          'Content-Type': 'image/png'
        },
        placeholder: (context, url) => const CircularProgressIndicator(),
        width: 90,
      );
    } else {
      return const Icon(Icons.apartment);
    }
  }
}
