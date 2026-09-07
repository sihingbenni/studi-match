import 'package:studi_match/models/coordinates.dart';

class WhereOutput {
  late final String cleanedPlace;
  late final String searchMode;
  late final List<Coordinates> coordinates;

  WhereOutput.fromEAJson(Map<String, dynamic> json) {
    cleanedPlace = json['bereinigterOrt']?.toString() ?? '';
    searchMode = json['suchmodus']?.toString() ?? '';
    coordinates = json['koordinaten'] != null
        ? (json['koordinaten'] as List)
            .map((e) => Coordinates.fromEAJson(e))
            .toList()
        : [];
  }
}
