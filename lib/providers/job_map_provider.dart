import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/firebase_options.dart';
import 'package:studi_match/models/address.dart';
import 'package:studi_match/models/coordinates.dart';

/// This class provides the Job Logo from the Employment Agency Api
class JobMapProvider {
  /// Returns the Job Logo as a CachedNetworkImage Widget
  static Future<StatelessWidget> getMap(Address? address) async {
    Coordinates? coordinates = address?.coordinates;
    if (coordinates != null &&
        !coordinates.lat.isNaN &&
        !coordinates.lon.isNaN) {
      double zoom = 13;

      // get the key from the firebase api
      String apiKey = DefaultFirebaseOptions.currentPlatform.apiKey;
      String url = 'https://maps.googleapis.com/maps/api/staticmap'
          '?center=${coordinates.lat},${coordinates.lon}'
          '&size=300x200'
          '&scale=2'
          '&key=$apiKey';
      // only show the marker, if there is a street
      if (address?.street != null) {
        url += '&markers=color:red|${coordinates.lat},${coordinates.lon}';
        url += '&zoom=${zoom.toInt()}';
      } else {
        zoom = zoom - min(address?.distance ?? 0, 4);
        url += '&zoom=${zoom.toInt()}';
      }

      return CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => const CircularProgressIndicator(),
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(Icons.question_mark);
    }
  }
}
