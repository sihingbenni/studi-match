
import 'package:studi_match/models/coordinates.dart';

class Address {
  late final String? zipCode;
  late final String? city;
  late final String? street;
  late final String? region;
  late final String? country;
  late final Coordinates? coordinates;
  late final double? distance;

  Address.fromEAJson(dynamic json) {

    if (json == null) {
      return;
    }

    zipCode = json['plz'];
    city = json['ort'];
    street = json['strasse'];
    region = json['region'];
    country = json['land'];
    coordinates = Coordinates.fromEAJson(json['koordinaten']);
    distance = json['entfernung'] != null ? double.parse(json['entfernung']) : null;
  }
}