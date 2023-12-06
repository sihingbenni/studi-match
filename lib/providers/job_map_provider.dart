

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/firebase_options.dart';
import 'package:studi_match/models/coordinates.dart';

/// This class provides the Job Logo from the Employment Agency Api
class JobMapProvider {

  /// Returns the Job Logo as a CachedNetworkImage Widget
  static Future<StatelessWidget> getMap(Coordinates? coordinates) async {
    if (coordinates != null && !coordinates.lat.isNaN && !coordinates.lon.isNaN) {

      String apiKey = DefaultFirebaseOptions.currentPlatform.apiKey;

      return CachedNetworkImage(
        imageUrl: 'https://maps.googleapis.com/maps/api/staticmap?center=${coordinates.lat},${coordinates.lon}&zoom=14&size=200x200&scale=2&key=$apiKey',
        placeholder: (context, url) => const CircularProgressIndicator(),
        width: 200,
      );
    } else {
      return const Icon(Icons.question_mark);
    }
  }
}