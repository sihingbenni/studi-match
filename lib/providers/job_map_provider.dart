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
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: const Color(0xFFE8ECEF),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.map_outlined, size: 36, color: Colors.blueGrey),
              const SizedBox(height: 4),
              Text(
                address?.city ?? 'Standort',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Tippen für Maps',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(Icons.question_mark);
    }
  }
}
