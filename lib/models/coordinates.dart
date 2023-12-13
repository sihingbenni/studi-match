
class Coordinates {
  late final double lat;
  late final double lon;

  Coordinates(this.lat, this.lon);

  Coordinates.fromEAJson(dynamic json) {

    if (json == null) {
      return;
    }

    lat = json['lat'];
    lon = json['lon'];
  }
}