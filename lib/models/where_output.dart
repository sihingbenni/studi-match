
import 'package:studi_match/models/coordinates.dart';

class WhereOutput {
  late final String cleanedPlace;
  late final String searchMode;
  late final List<Coordinates> coordinates;

  WhereOutput.fromEAJson(Map<String, dynamic> json) {
    cleanedPlace = json['bereinigterOrt'];
    searchMode = json['suchmodus'];
    coordinates = json['koordinaten'].map((e) => Coordinates.fromEAJson(e.cast<String, dynamic>())).cast<Coordinates>().toList();
  }
}