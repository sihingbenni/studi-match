import 'package:studi_match/models/coordinates.dart';

class Address {
  late final String? zipCode;
  late final String? city;
  late final String? street;
  late final String? region;
  late final String? country;
  late final Coordinates? coordinates;
  late final double? distance;

  Address.fromEAJson(dynamic json, [dynamic rootDistance]) {
    if (json == null) {
      zipCode = null;
      city = null;
      street = null;
      region = null;
      country = null;
      coordinates = null;
      distance = null;
      return;
    }

    final addrMap = (json is Map && json['adresse'] is Map) ? json['adresse'] : json;

    zipCode = addrMap['plz']?.toString();
    city = addrMap['ort']?.toString();
    final streetName = addrMap['strasse']?.toString();
    final houseNumber = addrMap['hausnummer']?.toString();
    if (streetName != null && houseNumber != null && houseNumber.isNotEmpty) {
      street = '$streetName $houseNumber';
    } else {
      street = streetName;
    }
    region = addrMap['region']?.toString();
    country = addrMap['land']?.toString();

    if (json is Map && json['koordinaten'] != null) {
      coordinates = Coordinates.fromEAJson(json['koordinaten']);
    } else if (json is Map && (json['breite'] != null || json['lat'] != null)) {
      coordinates = Coordinates.fromEAJson(json);
    } else {
      coordinates = null;
    }

    final rawDist = (json is Map && json['entfernung'] != null) ? json['entfernung'] : rootDistance;
    if (rawDist != null) {
      if (rawDist is num) {
        distance = rawDist.toDouble();
      } else {
        distance = double.tryParse(rawDist.toString());
      }
    } else {
      distance = null;
    }
  }

  @override
  String toString() => '$street, $zipCode $city, $region, $country, $distance';
}
