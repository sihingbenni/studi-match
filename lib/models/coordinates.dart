
class Coordinates {
  late final double lat;
  late final double lon;

  Coordinates.fromEAJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }
}