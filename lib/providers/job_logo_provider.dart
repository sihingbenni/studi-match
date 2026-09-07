import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/utilities/logger.dart';

/// This class provides the Job Logo from the Employment Agency Api
class JobLogoProvider {
  /// Returns the Job Logo as a Widget
  static Future<Widget> getLogo(String? logoHashId) async {
    if (logoHashId != null && logoHashId.isNotEmpty) {
      return CachedNetworkImage(
          imageUrl:
              'https://${ConfigProvider.baseUrl}${ConfigProvider.jobLogoEndpoint}${Uri.encodeComponent(logoHashId)}',
          httpHeaders: {
            ConfigProvider.apiKeyHeader: ConfigProvider.apiKey,
          },
          placeholder: (context, url) => const SizedBox(
                width: 90,
                height: 90,
                child: Center(child: CircularProgressIndicator()),
              ),
          width: 90,
          errorWidget: (context, url, error) {
            logger.d('Logo not available for hash $logoHashId');
            return const Icon(Icons.apartment, size: 60);
          });
    } else {
      return const Icon(Icons.apartment, size: 60);
    }
  }
}
