class Coordinates {
  late final double lat;
  late final double lon;

  Coordinates(this.lat, this.lon);

  Coordinates.fromEAJson(dynamic json) {
    if (json == null) {
      lat = 0.0;
      lon = 0.0;
      return;
    }

    final rawLat = json['lat'] ?? json['breite'] ?? 0.0;
    final rawLon = json['lon'] ?? json['laenge'] ?? 0.0;
    lat = (rawLat is num) ? rawLat.toDouble() : (double.tryParse(rawLat.toString()) ?? 0.0);
    lon = (rawLon is num) ? rawLon.toDouble() : (double.tryParse(rawLon.toString()) ?? 0.0);
  }
}
