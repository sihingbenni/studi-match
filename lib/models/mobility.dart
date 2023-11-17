class Mobility {
  late final bool isVehicleRequired;

  Mobility.fromEAJson(dynamic json) {
    if (json == null) {
      return;
    }
    isVehicleRequired = json['fahrzeugErforderlich'];
  }
}
