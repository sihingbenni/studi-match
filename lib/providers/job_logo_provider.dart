import 'package:cached_network_image/cached_network_image.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/services/employment_agency/oauth_service.dart';

/// This class provides the Job Logo from the Employment Agency Api
class JobLogoProvider {

  /// Returns the Job Logo as a CachedNetworkImage Widget
  static Future<CachedNetworkImage> getLogo(String? logoHashId) async {
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
        // TODO return a loading image when loading
      );
    }
    // TODO return a placeholder image if there is no job logo e.g. icon of house
    return CachedNetworkImage(imageUrl: 'https://via.placeholder.com/150');
  }
}
